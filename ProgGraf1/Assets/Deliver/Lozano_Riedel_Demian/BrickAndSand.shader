// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "HeightMap"
{
	Properties
	{
		_Heightmap1("Heightmap1", 2D) = "white" {}
		_Direction("Direction", Vector) = (1,1,1,0)
		_Heightmap2("Heightmap2", 2D) = "white" {}
		_Albedo("Albedo", 2D) = "white" {}
		_HMap1Mult("HMap1 Mult", Float) = 0
		_HMap2Mult("HMap2 Mult", Float) = 0
		_Float0("Float 0", Float) = 1
		_Lerp("Lerp", Float) = 0.3
		_Tiling("Tiling", Vector) = (5,5,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "Tessellation.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.6
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
		};

		uniform sampler2D _Heightmap1;
		uniform float2 _Tiling;
		uniform float _HMap1Mult;
		uniform sampler2D _Heightmap2;
		uniform float3 _Direction;
		uniform float _HMap2Mult;
		uniform float _Lerp;
		uniform float _Float0;
		uniform sampler2D _Albedo;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityEdgeLengthBasedTess (v0.vertex, v1.vertex, v2.vertex, 0.0);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_TexCoord86 = v.texcoord.xy * _Tiling;
			float2 MaterialTiling91 = uv_TexCoord86;
			float4 lerpResult84 = lerp( ( tex2Dlod( _Heightmap1, float4( MaterialTiling91, 0, 0.0) ) * float4( float3(0,1,0) , 0.0 ) * _HMap1Mult ) , ( tex2Dlod( _Heightmap2, float4( MaterialTiling91, 0, 0.0) ) * float4( _Direction , 0.0 ) * _HMap2Mult ) , _Lerp);
			float4 break81 = lerpResult84;
			float clampResult83 = clamp( break81.g , 0.0 , _Float0 );
			float4 appendResult82 = (float4(break81.r , clampResult83 , break81.b , 0.0));
			v.vertex.xyz += appendResult82.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TexCoord86 = i.uv_texcoord * _Tiling;
			float2 MaterialTiling91 = uv_TexCoord86;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV97 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode97 = ( 0.0 + 0.96 * pow( 1.0 - fresnelNdotV97, 0.43 ) );
			o.Albedo = ( tex2D( _Albedo, MaterialTiling91 ) * fresnelNode97 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.6
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
27;693;2521;667;469.4619;666.0471;1;True;False
Node;AmplifyShaderEditor.Vector2Node;87;-702.5107,-851.4026;Inherit;False;Property;_Tiling;Tiling;15;0;Create;True;0;0;0;False;0;False;5,5;30,30;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;86;-285.5168,-858.9833;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;58;-1190.052,-339.5295;Inherit;False;929.6606;609.0651;SandOffSet;6;68;67;64;63;62;93;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;59;-1177.022,429.2009;Inherit;False;929.6606;609.0651;Bricks;6;69;66;65;61;60;94;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;91;137.2134,-852.022;Inherit;False;MaterialTiling;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;93;-1042.643,-9.177917;Inherit;False;91;MaterialTiling;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;94;-1081.646,742.2222;Inherit;False;91;MaterialTiling;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;62;-1140.052,-284.1285;Inherit;True;Property;_Heightmap1;Heightmap1;1;0;Create;True;0;0;0;False;0;False;9789d23040cb1fb45ad60392430c3c15;5afe5582df30721448e7a290c5c73fbb;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;61;-1127.021,484.6019;Inherit;True;Property;_Heightmap2;Heightmap2;4;0;Create;True;0;0;0;False;0;False;b757e85527dfa9340b0a6ad2abe40137;9789d23040cb1fb45ad60392430c3c15;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;63;-871.8556,-289.5294;Inherit;True;Property;_TextureSample5;Texture Sample 5;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;60;-713.2096,922.2665;Inherit;False;Property;_HMap2Mult;HMap2 Mult;11;0;Create;True;0;0;0;False;0;False;0;0.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;66;-719.0695,712.2709;Inherit;False;Property;_Direction;Direction;2;0;Create;True;0;0;0;False;0;False;1,1,1;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;65;-858.8236,479.2009;Inherit;True;Property;_TextureSample3;Texture Sample 3;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector3Node;64;-732.1005,-56.46008;Inherit;False;Constant;_Vector2;Vector 2;1;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;67;-726.2416,153.5348;Inherit;False;Property;_HMap1Mult;HMap1 Mult;9;0;Create;True;0;0;0;False;0;False;0;0.18;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-114.8214,288.8141;Inherit;False;Property;_Lerp;Lerp;14;0;Create;True;0;0;0;False;0;False;0.3;0.27;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-409.3587,545.6939;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;68;-422.3907,-223.0366;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;84;22.88432,93.7404;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;79;323.1485,6.315152;Inherit;False;688.1;383.3;Clamp Height;4;83;82;81;80;;1,1,1,1;0;0
Node;AmplifyShaderEditor.BreakToComponentsNode;81;373.1486,68.61443;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.GetLocalVarNode;92;-25.58658,-405.622;Inherit;False;91;MaterialTiling;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;100;393.155,-97.23401;Inherit;False;Constant;_Float1;Float 1;16;0;Create;True;0;0;0;False;0;False;0.43;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;73;166.5671,-595.4041;Inherit;True;Property;_Albedo;Albedo;7;0;Create;True;0;0;0;False;0;False;662d72b6ec210cf4cbeec2b4d3cb8b2a;1d5d9561a88dd694cbd6597eed64e574;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.CommentaryNode;55;-4036.277,-1791.377;Inherit;False;2160.165;2323.114;Suelo - 1;11;38;39;51;53;50;45;10;15;11;16;54;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;80;414.1485,273.6146;Inherit;False;Property;_Float0;Float 0;13;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;377.555,-197.334;Inherit;False;Constant;_Float2;Float 2;16;0;Create;True;0;0;0;False;0;False;0.96;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;75;460.4631,-573.9229;Inherit;True;Property;_TextureSample6;Texture Sample 6;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;83;605.4485,164.1146;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;38;-3986.276,-708.0629;Inherit;False;929.6606;609.0651;SandOffSet;5;34;35;36;37;33;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;50;-2614.211,-591.2458;Inherit;False;688.1;383.3;Clamp Height;4;46;48;47;49;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FresnelNode;97;620.6549,-259.7341;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;39;-3973.245,60.6675;Inherit;False;929.6606;609.0651;Bricks;5;44;43;42;41;40;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;1057.455,-423.534;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;45;-2914.475,-503.8205;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.EdgeLengthTessNode;8;1187.697,190.3751;Inherit;False;1;0;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-3205.582,177.1605;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;33;-3936.276,-652.662;Inherit;True;Property;_OverHeightmap;OverHeightmap;0;0;Create;True;0;0;0;False;0;False;9789d23040cb1fb45ad60392430c3c15;9789d23040cb1fb45ad60392430c3c15;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ClampOpNode;47;-2331.911,-433.4466;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;53;-2685.89,-965.6624;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-3509.433,553.733;Inherit;False;Property;_BrickHeight;BrickHeight;10;0;Create;True;0;0;0;False;0;False;0;6.54;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;82;850.2485,56.31444;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TexturePropertyNode;15;-3644.229,-1741.377;Inherit;True;Property;_OverText;OverText;6;0;Create;True;0;0;0;False;0;False;662d72b6ec210cf4cbeec2b4d3cb8b2a;662d72b6ec210cf4cbeec2b4d3cb8b2a;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;34;-3668.079,-658.0629;Inherit;True;Property;_TextureSample4;Texture Sample 4;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;49;-2523.211,-323.9466;Inherit;False;Property;_ClampHeight;ClampHeight;12;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;16;-3329.232,-1723.377;Inherit;True;Property;_TextureSample2;Texture Sample 2;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;48;-2087.111,-541.2466;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.LerpOp;54;-2489.941,-1389.666;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector3Node;36;-3528.324,-424.9936;Inherit;False;Constant;_Vector1;Vector 1;1;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-3218.614,-591.5701;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;46;-2564.211,-528.9465;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.Vector3Node;42;-3515.293,343.7375;Inherit;False;Constant;_Vector0;Vector 0;1;0;Create;True;0;0;0;False;0;False;0,1,0;0,0,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SamplerNode;11;-3336.213,-1504.266;Inherit;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;40;-3655.047,110.6675;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;37;-3522.465,-214.9986;Inherit;False;Property;_SandHeight;SandHeight;8;0;Create;True;0;0;0;False;0;False;0;1.35;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;44;-3923.245,116.0685;Inherit;True;Property;_UnderHeightmap;UnderHeightmap;3;0;Create;True;0;0;0;False;0;False;b757e85527dfa9340b0a6ad2abe40137;9f8d9d9e60979574ea22974d2e2c08d4;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.VoronoiNode;51;-2993.806,-1104.544;Inherit;False;0;0;1;0;1;False;1;False;False;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TexturePropertyNode;10;-3655.211,-1522.266;Inherit;True;Property;_UnderText;UnderText;5;0;Create;True;0;0;0;False;0;False;691a8d46920a79542ad4e36c394b547a;b97db8acddac10d4c867939fcd38e487;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1454.871,-222.3984;Float;False;True;-1;6;ASEMaterialInspector;0;0;Standard;HeightMap;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;86;0;87;0
WireConnection;91;0;86;0
WireConnection;63;0;62;0
WireConnection;63;1;93;0
WireConnection;65;0;61;0
WireConnection;65;1;94;0
WireConnection;69;0;65;0
WireConnection;69;1;66;0
WireConnection;69;2;60;0
WireConnection;68;0;63;0
WireConnection;68;1;64;0
WireConnection;68;2;67;0
WireConnection;84;0;68;0
WireConnection;84;1;69;0
WireConnection;84;2;85;0
WireConnection;81;0;84;0
WireConnection;75;0;73;0
WireConnection;75;1;92;0
WireConnection;83;0;81;1
WireConnection;83;2;80;0
WireConnection;97;2;101;0
WireConnection;97;3;100;0
WireConnection;98;0;75;0
WireConnection;98;1;97;0
WireConnection;45;0;41;0
WireConnection;45;1;35;0
WireConnection;45;2;53;0
WireConnection;41;0;40;0
WireConnection;41;1;42;0
WireConnection;41;2;43;0
WireConnection;47;0;46;1
WireConnection;47;2;49;0
WireConnection;53;0;51;0
WireConnection;82;0;81;0
WireConnection;82;1;83;0
WireConnection;82;2;81;2
WireConnection;34;0;33;0
WireConnection;16;0;15;0
WireConnection;48;0;46;0
WireConnection;48;1;47;0
WireConnection;48;2;46;2
WireConnection;54;0;11;0
WireConnection;54;1;16;0
WireConnection;54;2;53;0
WireConnection;35;0;34;0
WireConnection;35;1;36;0
WireConnection;35;2;37;0
WireConnection;46;0;45;0
WireConnection;11;0;10;0
WireConnection;40;0;44;0
WireConnection;0;0;98;0
WireConnection;0;11;82;0
WireConnection;0;14;8;0
ASEEND*/
//CHKSM=1BC6B5118FBB8685B1FD217BD4BB8ECA23ECEAC2