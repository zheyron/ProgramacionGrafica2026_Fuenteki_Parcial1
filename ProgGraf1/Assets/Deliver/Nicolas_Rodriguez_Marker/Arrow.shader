// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Arrow"
{
	Properties
	{
		_ArrowTexture("Arrow Texture", 2D) = "white" {}
		_ColorIntensity("Color Intensity", Range( 0 , 1)) = 0
		_ArrowColor("Arrow Color", Color) = (0.990566,0.004672492,0.004672492,0)
		_Opacity("Opacity", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" }
		Cull Off
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#pragma target 3.0
		#pragma surface surf StandardCustomLighting alpha:fade keepalpha noshadow exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
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

		uniform sampler2D _ArrowTexture;
		uniform float4 _ArrowTexture_ST;
		uniform float _Opacity;
		uniform float4 _ArrowColor;
		uniform float _ColorIntensity;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			//Calculate new billboard vertex position and normal;
			float3 upCamVec = float3( 0, 1, 0 );
			float3 forwardCamVec = -normalize ( UNITY_MATRIX_V._m20_m21_m22 );
			float3 rightCamVec = normalize( UNITY_MATRIX_V._m00_m01_m02 );
			float4x4 rotationCamMatrix = float4x4( rightCamVec, 0, upCamVec, 0, forwardCamVec, 0, 0, 0, 0, 1 );
			v.normal = normalize( mul( float4( v.normal , 0 ), rotationCamMatrix )).xyz;
			v.vertex.x *= length( unity_ObjectToWorld._m00_m10_m20 );
			v.vertex.y *= length( unity_ObjectToWorld._m01_m11_m21 );
			v.vertex.z *= length( unity_ObjectToWorld._m02_m12_m22 );
			v.vertex = mul( v.vertex, rotationCamMatrix );
			v.vertex.xyz += unity_ObjectToWorld._m03_m13_m23;
			//Need to nullify rotation inserted by generated surface shader;
			v.vertex = mul( unity_WorldToObject, v.vertex );
			float3 ase_vertex3Pos = v.vertex.xyz;
			v.vertex.xyz += ( 0 * ase_vertex3Pos.y );
			v.vertex.w = 1;
		}

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			float2 uv_ArrowTexture = i.uv_texcoord * _ArrowTexture_ST.xy + _ArrowTexture_ST.zw;
			float4 tex2DNode1 = tex2D( _ArrowTexture, uv_ArrowTexture );
			c.rgb = ( _ArrowColor * _ColorIntensity ).rgb;
			c.a = ( tex2DNode1.a * _Opacity );
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			float2 uv_ArrowTexture = i.uv_texcoord * _ArrowTexture_ST.xy + _ArrowTexture_ST.zw;
			float4 tex2DNode1 = tex2D( _ArrowTexture, uv_ArrowTexture );
			o.Albedo = tex2DNode1.rgb;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
7;388;1920;607;1590.067;587.3298;1.636099;False;False
Node;AmplifyShaderEditor.PosVertexDataNode;3;-528.2688,342.1861;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BillboardNode;2;-515.5438,251.2372;Inherit;False;Cylindrical;True;0;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-614.8853,-178.83;Inherit;False;Property;_Opacity;Opacity;3;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-610.4283,127.5153;Inherit;False;Property;_ColorIntensity;Color Intensity;1;0;Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;9;-548.9965,-63.82803;Inherit;False;Property;_ArrowColor;Arrow Color;2;0;Create;True;0;0;0;False;0;False;0.990566,0.004672492,0.004672492,0;0.990566,0.004672492,0.004672492,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-599.4449,-405.9592;Inherit;True;Property;_ArrowTexture;Arrow Texture;0;0;Create;True;0;0;0;False;0;False;-1;dc99111e893bc92498fb4d68d8c9f5cb;dc99111e893bc92498fb4d68d8c9f5cb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-219.2688,336.1861;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-262.4125,-175.2334;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-229.5331,33.68617;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;111.0007,-14.12737;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;Arrow;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Spherical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;4;0;2;0
WireConnection;4;1;3;2
WireConnection;12;0;1;4
WireConnection;12;1;13;0
WireConnection;11;0;9;0
WireConnection;11;1;10;0
WireConnection;0;0;1;0
WireConnection;0;9;12;0
WireConnection;0;13;11;0
WireConnection;0;11;4;0
ASEEND*/
//CHKSM=71C8B622E9041B0305E2BD123BB20F4A00FA1F50