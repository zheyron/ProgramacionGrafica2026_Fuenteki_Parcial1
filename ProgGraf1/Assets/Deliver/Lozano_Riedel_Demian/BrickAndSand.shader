// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HeightMap"
{
	Properties
	{
		_OverHeightmap("OverHeightmap", 2D) = "white" {}
		_UnderHeightmap("UnderHeightmap", 2D) = "white" {}
		_UnderText("UnderText", 2D) = "white" {}
		_OverText("OverText", 2D) = "white" {}
		_SandHeight("SandHeight", Float) = 0
		_BrickHeight("BrickHeight", Float) = 0
		_ClampHeight("ClampHeight", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _UnderHeightmap;
		uniform float4 _UnderHeightmap_ST;
		uniform float _BrickHeight;
		uniform sampler2D _OverHeightmap;
		uniform float4 _OverHeightmap_ST;
		uniform float _SandHeight;
		uniform float _ClampHeight;
		uniform sampler2D _UnderText;
		uniform float4 _UnderText_ST;
		uniform sampler2D _OverText;
		uniform float4 _OverText_ST;


		float2 voronoihash51( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi51( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
		{
			float2 n = floor( v );
			float2 f = frac( v );
			float F1 = 8.0;
			float F2 = 8.0; float2 mg = 0;
			for ( int j = -1; j <= 1; j++ )
			{
				for ( int i = -1; i <= 1; i++ )
			 	{
			 		float2 g = float2( i, j );
			 		float2 o = voronoihash51( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 		if( d<F1 ) {
			 			F2 = F1;
			 			F1 = d; mg = g; mr = r; id = o;
			 		} else if( d<F2 ) {
			 			F2 = d;
			 		}
			 	}
			}
			return F1;
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 0.0);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_UnderHeightmap = v.texcoord * _UnderHeightmap_ST.xy + _UnderHeightmap_ST.zw;
			float2 uv_OverHeightmap = v.texcoord * _OverHeightmap_ST.xy + _OverHeightmap_ST.zw;
			float time51 = 0.0;
			float2 coords51 = v.texcoord.xy * 0.0;
			float2 id51 = 0;
			float2 uv51 = 0;
			float voroi51 = voronoi51( coords51, time51, id51, uv51, 0 );
			float smoothstepResult53 = smoothstep( 0.0 , 1.0 , voroi51);
			float4 lerpResult45 = lerp( ( tex2Dlod( _UnderHeightmap, float4( uv_UnderHeightmap, 0, 0.0) ) * float4( float3(0,1,0) , 0.0 ) * _BrickHeight ) , ( tex2Dlod( _OverHeightmap, float4( uv_OverHeightmap, 0, 0.0) ) * float4( float3(0,1,0) , 0.0 ) * _SandHeight ) , smoothstepResult53);
			float4 break46 = lerpResult45;
			float clampResult47 = clamp( break46.g , 0.0 , _ClampHeight );
			float4 appendResult48 = (float4(break46.r , clampResult47 , break46.b , 0.0));
			v.vertex.xyz += appendResult48.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_UnderText = i.uv_texcoord * _UnderText_ST.xy + _UnderText_ST.zw;
			float2 uv_OverText = i.uv_texcoord * _OverText_ST.xy + _OverText_ST.zw;
			float time51 = 0.0;
			float2 coords51 = i.uv_texcoord * 0.0;
			float2 id51 = 0;
			float2 uv51 = 0;
			float voroi51 = voronoi51( coords51, time51, id51, uv51, 0 );
			float smoothstepResult53 = smoothstep( 0.0 , 1.0 , voroi51);
			float4 lerpResult54 = lerp( tex2D( _UnderText, uv_UnderText ) , tex2D( _OverText, uv_OverText ) , smoothstepResult53);
			o.Albedo = lerpResult54.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
35;870;2521;501;1812.065;-359.9791;1.3;True;False
Node;AmplifyShaderEditor.CommentaryNode;38;-1635.61,848.2626;Inherit;False;929.6606;609.0651;SandOffSet;5;34;35;36;37;33;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;39;-1627.524,1616.993;Inherit;False;929.6606;609.0651;Bricks;5;44;43;42;41;40;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;44;-1577.524,1672.394;Inherit;True;Property;_UnderHeightmap;UnderHeightmap;1;0;Create;True;0;0;0;False;0;False;b757e85527dfa9340b0a6ad2abe40137;9789d23040cb1fb45ad60392430c3c15;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;33;-1585.61,903.6634;Inherit;True;Property;_OverHeightmap;OverHeightmap;0;0;Create;True;0;0;0;False;0;False;9789d23040cb1fb45ad60392430c3c15;9789d23040cb1fb45ad60392430c3c15;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;34;-1317.412,898.2626;Inherit;True;Property;_TextureSample4;Texture Sample 4;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;36;-1177.658,1131.332;Inherit;False;Constant;_Vector1;Vector 1;1;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;43;-1163.712,2110.058;Inherit;False;Property;_BrickHeight;BrickHeight;5;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;51;-643.1394,451.7815;Inherit;False;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.SamplerNode;40;-1309.325,1666.993;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;42;-1169.572,1900.063;Inherit;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;37;-1171.799,1341.327;Inherit;False;Property;_SandHeight;SandHeight;4;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-867.9479,964.7554;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-859.861,1733.486;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SmoothstepOpNode;53;-335.2239,590.6631;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;50;-263.5449,965.0797;Inherit;False;688.1;383.3;Clamp Height;4;46;48;47;49;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;45;-563.8079,1052.505;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-172.5448,1232.379;Inherit;False;Property;_ClampHeight;ClampHeight;6;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;10;-1304.545,34.05907;Inherit;True;Property;_UnderText;UnderText;2;0;Create;True;0;0;0;False;0;False;691a8d46920a79542ad4e36c394b547a;662d72b6ec210cf4cbeec2b4d3cb8b2a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;15;-1293.563,-185.051;Inherit;True;Property;_OverText;OverText;3;0;Create;True;0;0;0;False;0;False;662d72b6ec210cf4cbeec2b4d3cb8b2a;662d72b6ec210cf4cbeec2b4d3cb8b2a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.BreakToComponentsNode;46;-213.5448,1027.379;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.ClampOpNode;47;18.75524,1122.879;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-985.5471,52.05907;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;16;-978.5654,-167.051;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;48;263.5551,1015.079;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;54;-139.2743,166.6597;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;8;214.9261,804.8672;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;525.7018,431.9461;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;HeightMap;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;34;0;33;0
WireConnection;40;0;44;0
WireConnection;35;0;34;0
WireConnection;35;1;36;0
WireConnection;35;2;37;0
WireConnection;41;0;40;0
WireConnection;41;1;42;0
WireConnection;41;2;43;0
WireConnection;53;0;51;0
WireConnection;45;0;41;0
WireConnection;45;1;35;0
WireConnection;45;2;53;0
WireConnection;46;0;45;0
WireConnection;47;0;46;1
WireConnection;47;2;49;0
WireConnection;11;0;10;0
WireConnection;16;0;15;0
WireConnection;48;0;46;0
WireConnection;48;1;47;0
WireConnection;48;2;46;2
WireConnection;54;0;11;0
WireConnection;54;1;16;0
WireConnection;54;2;53;0
WireConnection;0;0;54;0
WireConnection;0;11;48;0
WireConnection;0;14;8;0
ASEEND*/
//CHKSM=607609D46C7C150B31B26CA1D09F66DBF1E3DBCD