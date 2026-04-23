// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SinCity_Effect"
{
	Properties
	{
		_ASEOutlineColor( "Outline Color", Color ) = (0,0,0,0)
		_ASEOutlineWidth( "Outline Width", Float ) = 0.005
		_NormalMap("Normal Map", 2D) = "white" {}
		_ColorShadow_1("Color Shadow_1", Color) = (1,1,1,0)
		_ColorShadow_2("Color Shadow_2", Color) = (0,0,0,0)
		_Albedo("Albedo", 2D) = "white" {}
		_Shadow_Force_Step_1("Shadow_Force_Step_1", Range( 0 , 1)) = 0
		_Shadow_Force_Step_2("Shadow_Force_Step_2", Range( 0 , 1)) = 0
		_Shadow_Force_Step_3("Shadow_Force_Step_3", Range( 0 , 1)) = 0
		_Shadow_Force_Step_4("Shadow_Force_Step_4", Range( 0 , 1)) = 0
		_RimColor("Rim Color", Color) = (1,1,1,0)
		_RimPower("Rim Power", Range( 0 , 1)) = 0
		_RimOffset("Rim Offset", Range( 0 , 1)) = 0.8
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ }
		Cull Front
		CGPROGRAM
		#pragma target 3.0
		#pragma surface outlineSurf Outline nofog  keepalpha noshadow noambient novertexlights nolightmap nodynlightmap nodirlightmap nometa noforwardadd vertex:outlineVertexDataFunc 
		
		float4 _ASEOutlineColor;
		float _ASEOutlineWidth;
		void outlineVertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			v.vertex.xyz += ( v.normal * _ASEOutlineWidth );
		}
		inline half4 LightingOutline( SurfaceOutput s, half3 lightDir, half atten ) { return half4 ( 0,0,0, s.Alpha); }
		void outlineSurf( Input i, inout SurfaceOutput o )
		{
			o.Emission = _ASEOutlineColor.rgb;
			o.Alpha = 1;
		}
		ENDCG
		

		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		Blend One OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform float4 _ColorShadow_1;
		uniform float4 _ColorShadow_2;
		uniform float _Shadow_Force_Step_1;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float _Shadow_Force_Step_2;
		uniform float _Shadow_Force_Step_3;
		uniform float _Shadow_Force_Step_4;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float _RimOffset;
		uniform float _RimPower;
		uniform float4 _RimColor;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = Unity_SafeNormalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 NormalMap78 = UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) );
			float dotResult3 = dot( ase_worldlightDir , normalize( (WorldNormalVector( i , NormalMap78 )) ) );
			float Dot_Result_From_LightDir10 = dotResult3;
			float StepsShadow22 = ( ( step( (0.0 + (_Shadow_Force_Step_1 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) , Dot_Result_From_LightDir10 ) + step( (0.0 + (_Shadow_Force_Step_2 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) , Dot_Result_From_LightDir10 ) + step( (0.0 + (_Shadow_Force_Step_3 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) , Dot_Result_From_LightDir10 ) + step( (0.0 + (_Shadow_Force_Step_4 - -1.0) * (1.0 - 0.0) / (1.0 - -1.0)) , Dot_Result_From_LightDir10 ) ) / 4.0 );
			float4 lerpResult131 = lerp( _ColorShadow_1 , _ColorShadow_2 , StepsShadow22);
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 AlbedoProperty86 = ( lerpResult131 * tex2D( _Albedo, uv_Albedo ) );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			UnityGI gi98 = gi;
			float3 diffNorm98 = WorldNormalVector( i , NormalMap78 );
			gi98 = UnityGI_Base( data, 1, diffNorm98 );
			float3 indirectDiffuse98 = gi98.indirect.diffuse + diffNorm98 * 0.0001;
			float4 Lighting93 = ( AlbedoProperty86 * ( ( ase_lightColor * ase_lightColor.a ) * float4( ( indirectDiffuse98 + ase_lightAtten ) , 0.0 ) ) );
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult60 = dot( ase_worldViewDir , normalize( (WorldNormalVector( i , NormalMap78 )) ) );
			float Dot_Result_From_ViewDir62 = dotResult60;
			float4 RimLight122 = ( saturate( ( ( Dot_Result_From_LightDir10 * ase_lightAtten ) * pow( ( 1.0 - saturate( ( Dot_Result_From_ViewDir62 + _RimOffset ) ) ) , _RimPower ) ) ) * ( _RimColor * ase_lightColor ) );
			c.rgb = ( Lighting93 + RimLight122 ).rgb;
			c.a = 1;
			c.rgb *= c.a;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardCustomLighting keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
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
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
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
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
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
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputCustomLightingCustom o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputCustomLightingCustom, o )
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
414;73;1195;456;1.150108;599.7858;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;81;-3709.89,-1934.594;Inherit;False;891.7764;280.295;Normal Map;3;76;78;77;Normal Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;76;-3659.89,-1884.389;Inherit;True;Property;_NormalMap;Normal Map;0;0;Create;True;0;0;0;False;0;False;None;14fbeebef2ed6094483d60b9041036bb;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;77;-3385.717,-1884.299;Inherit;True;Property;_TextureSample2;Texture Sample 2;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;78;-3042.114,-1884.594;Inherit;False;NormalMap;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;72;-2746.37,-1932.661;Inherit;False;1254.18;1137.74;DOT Results;4;63;36;79;80;DOT RESULTS;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;36;-2482.105,-1250.388;Inherit;False;679.609;385.1234;DOT Result from 'LightDir';4;10;3;2;52;DOT.LightDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-2670.486,-1051.792;Inherit;False;78;NormalMap;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldNormalVector;2;-2420.351,-1048.265;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;52;-2447.259,-1201.196;Inherit;False;True;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;57;1427.012,-1312.912;Inherit;False;1360.121;1172.11;Steps Calculation;19;27;53;5;26;20;17;54;55;9;16;11;13;14;4;56;18;12;21;22;Steps Calculation;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;3;-2198.354,-1129.154;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;1494.004,-431.3416;Inherit;False;Property;_Shadow_Force_Step_4;Shadow_Force_Step_4;9;0;Create;True;0;0;0;False;0;False;0;0.9;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;1478.002,-1262.913;Inherit;False;Property;_Shadow_Force_Step_1;Shadow_Force_Step_1;6;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;1477.012,-984.386;Inherit;False;Property;_Shadow_Force_Step_2;Shadow_Force_Step_2;7;0;Create;True;0;0;0;False;0;False;0;0.3;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;10;-2049.457,-1134.748;Inherit;False;Dot_Result_From_LightDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;1491.889,-705.9575;Inherit;False;Property;_Shadow_Force_Step_3;Shadow_Force_Step_3;8;0;Create;True;0;0;0;False;0;False;0;0.6;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;79;-2698.887,-1576.517;Inherit;False;78;NormalMap;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;63;-2522.765,-1776.028;Inherit;False;758.8868;387.141;DOT Result from 'ViewDir';4;58;60;62;59;DOT.ViewDir;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCRemapNode;20;1834.402,-699.7916;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;58;-2460.064,-1726.028;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;17;1840.807,-531.4185;Inherit;False;10;Dot_Result_From_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;9;1832.293,-1258.062;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;11;1840.898,-1090.689;Inherit;False;10;Dot_Result_From_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;54;1836.516,-425.1746;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;13;1841.772,-807.2377;Inherit;False;10;Dot_Result_From_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;16;1835.494,-978.241;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;55;1842.921,-256.8018;Inherit;False;10;Dot_Result_From_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldNormalVector;59;-2472.765,-1571.887;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StepOpNode;18;2038.776,-618.6046;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;56;2040.889,-343.9877;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;4;2037.668,-1181.876;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;14;2043.869,-895.0552;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;60;-2226.707,-1650.288;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;-2044.877,-1655.842;Inherit;False;Dot_Result_From_ViewDir;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;105;-3371.039,-715.474;Inherit;False;1880.514;776.3695;;17;118;117;115;106;119;121;120;112;116;114;113;111;110;109;108;107;122;Rim Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;2233.863,-920.9523;Inherit;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;119;-3311.757,-446.493;Inherit;False;62;Dot_Result_From_ViewDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;21;2418.482,-921.4294;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-3325.913,-346.019;Float;False;Property;_RimOffset;Rim Offset;12;0;Create;True;0;0;0;False;0;False;0.8;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;2563.133,-926.3652;Inherit;False;StepsShadow;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;87;94.56447,-2298.366;Inherit;False;1349.312;928.7657;Albedo;9;134;133;86;85;131;82;130;83;84;Albedo Property;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;107;-3038.917,-406.0191;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;104;-1320.42,-1182.964;Inherit;False;1232.484;846.561;Light section;10;93;92;103;90;102;94;98;91;100;99;Light section;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexturePropertyNode;83;361.6855,-1615.74;Inherit;True;Property;_Albedo;Albedo;5;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;134;492.9249,-1767.251;Inherit;False;22;StepsShadow;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;108;-2878.917,-406.0191;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;130;483.9971,-2046.609;Inherit;False;Property;_ColorShadow_2;Color Shadow_2;4;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;84;484.6626,-2245.203;Inherit;False;Property;_ColorShadow_1;Color Shadow_1;3;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.5188679,0.5188679,0.5188679,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;110;-2823.917,-304.019;Float;False;Property;_RimPower;Rim Power;11;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;120;-2764.76,-610.4929;Inherit;False;10;Dot_Result_From_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;121;-2709.76,-518.4931;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;131;811.9137,-1942.529;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;99;-1273.289,-701.0909;Inherit;False;78;NormalMap;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;82;622.7268,-1616.016;Inherit;True;Property;_TextureSample3;Texture Sample 3;10;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;109;-2702.917,-406.0191;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;112;-2488.917,-569.0192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;111;-2510.917,-406.0191;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;100;-1062.289,-608.0909;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;98;-1086.289,-696.0909;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;1001.464,-1840.702;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;91;-1076.022,-894.6179;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-2271.917,-473.0192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;86;1205.46,-1944.33;Inherit;False;AlbedoProperty;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;102;-831.2897,-672.0909;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;113;-2337.917,-322.019;Float;False;Property;_RimColor;Rim Color;10;0;Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LightColorNode;114;-2283.917,-145.0193;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-893.5231,-895.0735;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;103;-687.2897,-802.0909;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;90;-746.045,-1063.964;Inherit;False;86;AlbedoProperty;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;117;-2072.915,-474.0192;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;-2089.915,-243.019;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;92;-503.0221,-931.6176;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;-1876.914,-474.0192;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;122;-1705.177,-478.6082;Inherit;False;RimLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-332.022,-935.6176;Inherit;False;Lighting;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;71;-1324.475,-1939.281;Inherit;False;1372.759;661.6814;Ramp;7;66;67;70;74;73;29;30;Ramp - Shadow;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;124;415.2554,-263.572;Inherit;False;122;RimLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;75;416.4922,-407.7477;Inherit;False;93;Lighting;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;30;-1266.431,-1562.615;Inherit;False;10;Dot_Result_From_LightDir;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;29;-933.2454,-1669.803;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;123;689.2558,-349.572;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-209.8993,-1573.514;Inherit;False;RampShadow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;67;-941.7717,-1476.301;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;73;-973.5098,-1881.135;Inherit;True;Property;_RampTexture;Ramp Texture;1;0;Create;True;0;0;0;False;0;False;None;c92f04f3c507cb649aedb4ba2ff262d1;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;74;-656.9189,-1572.615;Inherit;True;Property;_TextureSample1;Texture Sample 1;9;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;133;489.9637,-1848.757;Inherit;False;70;RampShadow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-1175.174,-1449.325;Inherit;False;Property;_RampScaleOffset;Ramp Scale/Offset;2;0;Create;True;0;0;0;False;0;False;0.5;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;849.4476,-679.2421;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;SinCity_Effect;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;3;1;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;True;0.005;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;77;0;76;0
WireConnection;78;0;77;0
WireConnection;2;0;80;0
WireConnection;3;0;52;0
WireConnection;3;1;2;0
WireConnection;10;0;3;0
WireConnection;20;0;27;0
WireConnection;9;0;5;0
WireConnection;54;0;53;0
WireConnection;16;0;26;0
WireConnection;59;0;79;0
WireConnection;18;0;20;0
WireConnection;18;1;17;0
WireConnection;56;0;54;0
WireConnection;56;1;55;0
WireConnection;4;0;9;0
WireConnection;4;1;11;0
WireConnection;14;0;16;0
WireConnection;14;1;13;0
WireConnection;60;0;58;0
WireConnection;60;1;59;0
WireConnection;62;0;60;0
WireConnection;12;0;4;0
WireConnection;12;1;14;0
WireConnection;12;2;18;0
WireConnection;12;3;56;0
WireConnection;21;0;12;0
WireConnection;22;0;21;0
WireConnection;107;0;119;0
WireConnection;107;1;106;0
WireConnection;108;0;107;0
WireConnection;131;0;84;0
WireConnection;131;1;130;0
WireConnection;131;2;134;0
WireConnection;82;0;83;0
WireConnection;109;0;108;0
WireConnection;112;0;120;0
WireConnection;112;1;121;0
WireConnection;111;0;109;0
WireConnection;111;1;110;0
WireConnection;98;0;99;0
WireConnection;85;0;131;0
WireConnection;85;1;82;0
WireConnection;115;0;112;0
WireConnection;115;1;111;0
WireConnection;86;0;85;0
WireConnection;102;0;98;0
WireConnection;102;1;100;0
WireConnection;94;0;91;0
WireConnection;94;1;91;2
WireConnection;103;0;94;0
WireConnection;103;1;102;0
WireConnection;117;0;115;0
WireConnection;116;0;113;0
WireConnection;116;1;114;0
WireConnection;92;0;90;0
WireConnection;92;1;103;0
WireConnection;118;0;117;0
WireConnection;118;1;116;0
WireConnection;122;0;118;0
WireConnection;93;0;92;0
WireConnection;29;0;30;0
WireConnection;123;0;75;0
WireConnection;123;1;124;0
WireConnection;70;0;74;0
WireConnection;67;0;30;0
WireConnection;67;1;66;0
WireConnection;67;2;66;0
WireConnection;74;0;73;0
WireConnection;74;1;29;0
WireConnection;0;13;123;0
ASEEND*/
//CHKSM=D628A16C8E40D039C04A67E4E0DA8652A33FE352