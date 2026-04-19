// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Island"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		[HideInInspector]_TerrainHolesTexture("_TerrainHolesTexture", 2D) = "white" {}
		[Toggle(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)] _EnablePerpixelNormals("Enable Per-pixel Normals", Float) = 0
		[HideInInspector]_Mask2("_Mask2", 2D) = "white" {}
		[HideInInspector]_Mask0("_Mask0", 2D) = "white" {}
		[HideInInspector]_Mask1("_Mask1", 2D) = "white" {}
		[HideInInspector]_Mask3("_Mask3", 2D) = "white" {}
		_TextureSample4("Texture Sample 3", 2D) = "white" {}
		_NormalScale("NormalScale", Range( 0 , 1)) = 0.1
		_Island_AlphaMask("Island_AlphaMask", Range( 0 , 0.5)) = 0.5
		_HeightTexture("HeightTexture", 2D) = "white" {}
		_TextureSample1("Texture Sample 1", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma shader_feature_local _TERRAIN_INSTANCED_PERPIXEL_NORMAL
		#pragma multi_compile_local __ _ALPHATEST_ON
		#pragma shader_feature_local _MASKMAP
		#pragma surface surf Lambert keepalpha addshadow fullforwardshadows vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform sampler2D _Mask1;
		uniform sampler2D _Mask0;
		uniform sampler2D _Mask3;
		uniform sampler2D _Mask2;
		uniform float4 _MaskMapRemapScale1;
		uniform float4 _MaskMapRemapScale0;
		uniform float4 _MaskMapRemapOffset1;
		uniform float4 _MaskMapRemapOffset2;
		uniform float4 _MaskMapRemapScale2;
		uniform float4 _MaskMapRemapScale3;
		uniform float4 _MaskMapRemapOffset0;
		uniform float4 _MaskMapRemapOffset3;
		uniform sampler2D _HeightTexture;
		uniform float4 _HeightTexture_ST;
		uniform sampler2D _TextureSample1;
		uniform float _NormalScale;
		uniform sampler2D _TextureSample4;
		uniform float4 _TextureSample4_ST;
		uniform sampler2D _TextureSample0;
		uniform sampler2D _TerrainHolesTexture;
		uniform float4 _TerrainHolesTexture_ST;
		uniform float _Island_AlphaMask;
		uniform float _Cutoff = 0.5;

		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			return UnityDistanceBasedTess( v0.vertex, v1.vertex, v2.vertex, 0.0,100.0,8.376471);
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float2 uv_HeightTexture = v.texcoord * _HeightTexture_ST.xy + _HeightTexture_ST.zw;
			float4 appendResult28 = (float4(0.0 , ( tex2Dlod( _HeightTexture, float4( uv_HeightTexture, 0, 0.0) ).g * 3.689999 ) , 0.0 , 0.0));
			float4 temp_cast_0 = (-1.0).xxxx;
			float4 temp_cast_1 = (17.64826).xxxx;
			float4 clampResult23 = clamp( ( appendResult28 * 3.689999 ) , temp_cast_0 , temp_cast_1 );
			v.vertex.xyz += clampResult23.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float4 appendResult7 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float4 WorldPositionUV8 = appendResult7;
			float3 temp_output_61_0_g1 = UnpackScaleNormal( tex2D( _TextureSample1, WorldPositionUV8.xy ), _NormalScale );
			#ifdef _TERRAIN_INSTANCED_PERPIXEL_NORMAL
				float3 staticSwitch84_g1 = temp_output_61_0_g1;
			#else
				float3 staticSwitch84_g1 = temp_output_61_0_g1;
			#endif
			o.Normal = staticSwitch84_g1;
			float2 uv_TextureSample4 = i.uv_texcoord * _TextureSample4_ST.xy + _TextureSample4_ST.zw;
			float4 clampResult36 = clamp( ( tex2D( _TextureSample4, uv_TextureSample4 ) * tex2D( _TextureSample0, WorldPositionUV8.xy ) ) , float4( 0.1981132,0.1256519,0.05700427,0 ) , float4( 1,1,1,0 ) );
			float4 temp_output_60_0_g1 = clampResult36;
			float4 localClipHoles100_g1 = ( temp_output_60_0_g1 );
			float2 uv_TerrainHolesTexture = i.uv_texcoord * _TerrainHolesTexture_ST.xy + _TerrainHolesTexture_ST.zw;
			float holeClipValue99_g1 = tex2D( _TerrainHolesTexture, uv_TerrainHolesTexture ).r;
			float Hole100_g1 = holeClipValue99_g1;
			{
			#ifdef _ALPHATEST_ON
				clip(Hole100_g1 == 0.0f ? -1 : 1);
			#endif
			}
			o.Albedo = localClipHoles100_g1.xyz;
			o.Alpha = 1;
			float2 uv_HeightTexture = i.uv_texcoord * _HeightTexture_ST.xy + _HeightTexture_ST.zw;
			clip( ( tex2D( _HeightTexture, uv_HeightTexture ) + _Island_AlphaMask ).r - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1913;143;1920;868;1837.402;735.48;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;9;-2171.121,-436.9612;Inherit;False;675.0381;303.2902;World Position UV;3;8;7;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;20;-2164.057,112.9891;Inherit;False;1260.338;565.6445;Height Map;7;17;16;19;18;26;27;28;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;6;-2121.12,-385.7139;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;16;-2154.959,173.8227;Inherit;True;Property;_HeightTexture;HeightTexture;30;0;Create;True;0;0;0;False;0;False;None;214dc6b9f1e165042b56cf5fb036c3ad;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.DynamicAppendNode;7;-1909.105,-386.9612;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;17;-1861.454,175.9476;Inherit;True;Property;_TextureSample2;Texture Sample 2;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;8;-1761.938,-375.7367;Inherit;False;WorldPositionUV;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1846.219,449.0337;Inherit;False;Constant;_HeightmapStrength;Heightmap Strength;4;0;Create;True;0;0;0;False;0;False;3.689999;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;26;-1530.038,263.4039;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SamplerNode;34;-1425.404,-662.4811;Inherit;True;Property;_TextureSample4;Texture Sample 3;26;0;Create;True;0;0;0;False;0;False;-1;None;214dc6b9f1e165042b56cf5fb036c3ad;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1372.664,-448.7409;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;662d72b6ec210cf4cbeec2b4d3cb8b2a;662d72b6ec210cf4cbeec2b4d3cb8b2a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-1392.77,435.6628;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-1071.727,12.51755;Inherit;False;Property;_Island_AlphaMask;Island_AlphaMask;29;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;28;-1227.319,260.6203;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1815.013,-76.7359;Inherit;False;Property;_NormalScale;NormalScale;28;0;Create;True;0;0;0;False;0;False;0.1;0.2352941;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;24;-862.5432,87.01465;Inherit;False;556;390;Amecetamiento;3;23;21;22;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-1023.404,-485.4811;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;29;-1385.861,-80.35504;Inherit;True;Property;_TextureSample3;Texture Sample 3;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;36;-813.4036,-430.4811;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0.1981132,0.1256519,0.05700427,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-812.5432,277.0149;Inherit;False;Constant;_IslandMinimumHeight;Island Minimum Height;4;0;Create;True;0;0;0;False;0;False;-1;0;-10;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-787.8554,608.9369;Inherit;False;Constant;_Tesselation;Tesselation;2;0;Create;True;0;0;0;False;0;False;8.376471;0;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-787.0425,-75.05328;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1061.72,258.5332;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-771.5432,358.015;Inherit;False;Constant;_IslandMaximumHeight;Island Maximum Height;4;0;Create;True;0;0;0;False;0;False;17.64826;0;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-803.5024,-224.8469;Inherit;False;Property;_Smoothness;Smoothness;27;0;Create;True;0;0;0;False;0;False;0.85;0.85;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-1323.337,-262.2672;Inherit;True;Property;_TextureSample1;Texture Sample 1;31;0;Create;True;0;0;0;False;0;False;-1;f53512d44b91e954dae7bf028209df1a;f53512d44b91e954dae7bf028209df1a;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;13;-568.1129,-358.704;Inherit;False;Four Splats First Pass Terrain;2;;1;37452fdfb732e1443b7e39720d05b708;2,85,1,102,1;7;59;FLOAT4;0,0,0,0;False;60;FLOAT4;0,0,0,0;False;61;FLOAT3;0,0,0;False;57;FLOAT;0;False;58;FLOAT;0;False;201;FLOAT;0;False;62;FLOAT;0;False;7;FLOAT4;0;FLOAT3;14;FLOAT;56;FLOAT;45;FLOAT;200;FLOAT;19;FLOAT3;17
Node;AmplifyShaderEditor.DistanceBasedTessNode;25;-450.5873,633.4702;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;100;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;23;-477.5432,137.0146;Inherit;False;3;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;2;FLOAT4;1,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;54,-142;Float;False;True;-1;6;ASEMaterialInspector;0;0;Lambert;Island;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;AlphaTest;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;6;1
WireConnection;7;1;6;3
WireConnection;17;0;16;0
WireConnection;8;0;7;0
WireConnection;26;0;17;0
WireConnection;1;1;8;0
WireConnection;27;0;26;1
WireConnection;27;1;19;0
WireConnection;28;1;27;0
WireConnection;35;0;34;0
WireConnection;35;1;1;0
WireConnection;29;0;16;0
WireConnection;36;0;35;0
WireConnection;31;0;29;0
WireConnection;31;1;32;0
WireConnection;18;0;28;0
WireConnection;18;1;19;0
WireConnection;2;1;8;0
WireConnection;2;5;33;0
WireConnection;13;60;36;0
WireConnection;13;61;2;0
WireConnection;13;58;14;0
WireConnection;13;62;31;0
WireConnection;25;0;3;0
WireConnection;23;0;18;0
WireConnection;23;1;21;0
WireConnection;23;2;22;0
WireConnection;0;0;13;0
WireConnection;0;1;13;14
WireConnection;0;10;13;19
WireConnection;0;11;23;0
WireConnection;0;14;25;0
ASEEND*/
//CHKSM=55BB0B83776073358979F06C8559FD2FBAB3CAEC