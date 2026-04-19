// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HeightMap"
{
	Properties
	{
		_OverHeightmap("OverHeightmap", 2D) = "white" {}
		_UnderHeightmap("UnderHeightmap", 2D) = "white" {}
		_UnderText("UnderText", 2D) = "white" {}
		_maxHeight("maxHeight", Range( -1 , 5)) = 0
		_Float1("Float 1", Range( -1 , 5)) = 0
		_minHeight("minHeight", Range( -1 , 5)) = 0
		_Float0("Float 0", Range( -1 , 5)) = 0
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

		uniform sampler2D _OverHeightmap;
		uniform float4 _OverHeightmap_ST;
		uniform float _minHeight;
		uniform float _maxHeight;
		uniform sampler2D _UnderHeightmap;
		uniform float4 _UnderHeightmap_ST;
		uniform float _Float0;
		uniform float _Float1;
		uniform sampler2D _UnderText;
		uniform float4 _UnderText_ST;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 0.0);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_OverHeightmap = v.texcoord * _OverHeightmap_ST.xy + _OverHeightmap_ST.zw;
			float4 temp_cast_1 = (_minHeight).xxxx;
			float4 temp_cast_2 = (_maxHeight).xxxx;
			float4 clampResult13 = clamp( ( tex2Dlod( _OverHeightmap, float4( uv_OverHeightmap, 0, 0.0) ) * float4( float3(0,1,0) , 0.0 ) ) , temp_cast_1 , temp_cast_2 );
			float2 uv_UnderHeightmap = v.texcoord * _UnderHeightmap_ST.xy + _UnderHeightmap_ST.zw;
			float4 temp_cast_4 = (_Float0).xxxx;
			float4 temp_cast_5 = (_Float1).xxxx;
			float4 clampResult28 = clamp( ( tex2Dlod( _UnderHeightmap, float4( uv_UnderHeightmap, 0, 0.0) ) * float4( float3(0,1,0) , 0.0 ) ) , temp_cast_4 , temp_cast_5 );
			v.vertex.xyz += ( clampResult13 * clampResult28 ).rgb;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_UnderText = i.uv_texcoord * _UnderText_ST.xy + _UnderText_ST.zw;
			float4 tex2DNode11 = tex2D( _UnderText, uv_UnderText );
			o.Albedo = tex2DNode11.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
-7;694;2560;714;3297.094;98.62505;1.766898;True;True
Node;AmplifyShaderEditor.CommentaryNode;19;-2670.294,281.4826;Inherit;False;1384.776;605.5439;Heights;7;3;6;4;5;7;14;13;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;21;-2418.62,1015.86;Inherit;False;1384.776;605.5439;Heights;7;28;27;26;25;24;23;22;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;22;-2368.62,1065.86;Inherit;True;Property;_UnderHeightmap;UnderHeightmap;1;0;Create;True;0;0;0;False;0;False;9789d23040cb1fb45ad60392430c3c15;9789d23040cb1fb45ad60392430c3c15;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;3;-2620.294,331.4826;Inherit;True;Property;_OverHeightmap;OverHeightmap;0;0;Create;True;0;0;0;False;0;False;9789d23040cb1fb45ad60392430c3c15;9789d23040cb1fb45ad60392430c3c15;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;24;-2053.621,1085.16;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;23;-2010.523,1353.16;Inherit;False;Constant;_Vector1;Vector 1;1;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.Vector3Node;6;-2262.196,618.7826;Inherit;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;4;-2305.295,350.7826;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-1850.322,666.0932;Inherit;False;Property;_minHeight;minHeight;6;0;Create;True;0;0;0;False;0;False;0;0;-1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1834.098,771.0266;Inherit;False;Property;_maxHeight;maxHeight;4;0;Create;True;0;0;0;False;0;False;0;0;-1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1687.094,473.3822;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1582.425,1505.404;Inherit;False;Property;_Float1;Float 1;5;0;Create;True;0;0;0;False;0;False;0;0;-1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1598.649,1400.47;Inherit;False;Property;_Float0;Float 0;7;0;Create;True;0;0;0;False;0;False;0;0;-1;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1435.421,1207.759;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;10;-1199.355,-368.0036;Inherit;True;Property;_UnderText;UnderText;2;0;Create;True;0;0;0;False;0;False;662d72b6ec210cf4cbeec2b4d3cb8b2a;662d72b6ec210cf4cbeec2b4d3cb8b2a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ClampOpNode;13;-1456.518,493.0488;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;28;-1204.845,1227.426;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;8;70.94407,587.2191;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-694.4812,335.1197;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-414.6921,-300.8752;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;15;-1212.373,-122.1137;Inherit;True;Property;_OverText;OverText;3;0;Create;True;0;0;0;False;0;False;662d72b6ec210cf4cbeec2b4d3cb8b2a;662d72b6ec210cf4cbeec2b4d3cb8b2a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;16;-897.3753,-104.1137;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;11;-880.3571,-350.0036;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-644.5026,104.1151;Inherit;False;Property;_TextureLerp;TextureLerp;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-389.6433,774.0118;Inherit;False;Property;_HeightLerp;HeightLerp;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;HeightMap;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;0;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;24;0;22;0
WireConnection;4;0;3;0
WireConnection;5;0;4;0
WireConnection;5;1;6;0
WireConnection;25;0;24;0
WireConnection;25;1;23;0
WireConnection;13;0;5;0
WireConnection;13;1;14;0
WireConnection;13;2;7;0
WireConnection;28;0;25;0
WireConnection;28;1;27;0
WireConnection;28;2;26;0
WireConnection;31;0;13;0
WireConnection;31;1;28;0
WireConnection;32;0;11;0
WireConnection;16;0;15;0
WireConnection;11;0;10;0
WireConnection;0;0;11;0
WireConnection;0;11;31;0
WireConnection;0;14;8;0
ASEEND*/
//CHKSM=913BDC8B03B11941029A4F90B92A689E2368D0EC