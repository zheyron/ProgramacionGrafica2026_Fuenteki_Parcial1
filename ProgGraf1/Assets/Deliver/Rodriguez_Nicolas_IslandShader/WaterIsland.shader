// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WaterIsland"
{
	Properties
	{
		_WaveStretch("WaveStretch", Vector) = (33,0.04,0,0)
		_WaveTileSize("Wave Tile Size", Range( 0.1 , 10)) = 0
		_Tesselation("Tesselation", Range( 0.1 , 15)) = 5
		_WaveFrequency("WaveFrequency", Range( 0 , 1)) = 0.85
		_WaveDirectionSpeed("WaveDirectionSpeed", Vector) = (1,0,0,0)
		_WaveHeight("WaveHeight", Range( 0 , 0.3)) = 1
		_WaterColor("WaterColor", Color) = (0,0,0,0)
		_TopColor("TopColor", Color) = (0,0,0,0)
		_EdgeDistance("Edge Distance", Range( 0 , 2)) = 1
		_EdgePower("Edge Power", Range( 0 , 0.9)) = 0
		_WaveUp_Y("WaveUp_Y", Range( 1 , 40)) = 34.3
		_NormalMap("NormalMap", 2D) = "white" {}
		_NormalPanSpeed2("Normal Pan Speed 2", Range( 0 , 1)) = 3
		_NormalTile("Normal Tile", Float) = 1
		_NormalStrength("Normal Strength", Range( 0 , 2)) = 0
		_NormalPanDirection1("Normal Pan Direction 1", Vector) = (1,0,0,0)
		_NormalPanDirection2("Normal Pan Direction 2", Vector) = (-1,0,0,0)
		_NormalPanSpeed1("Normal Pan Speed 1", Range( 0 , 1)) = 1
		_EdgeFoamTexture("EdgeFoamTexture", 2D) = "white" {}
		_EdgeFoamTile("Edge Foam Tile", Float) = 1
		_SeaFoamTile("Sea Foam Tile", Float) = 1
		_FoamMask("FoamMask", Range( 0 , 0.1)) = 0
		_SeaFoamStrength("Sea Foam Strength", Range( 0 , 1)) = 0.1
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Lambert keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
			float4 screenPos;
		};

		uniform float _WaveUp_Y;
		uniform float _WaveHeight;
		uniform float _WaveFrequency;
		uniform float2 _WaveDirectionSpeed;
		uniform float2 _WaveStretch;
		uniform float _WaveTileSize;
		uniform sampler2D _NormalMap;
		uniform float2 _NormalPanDirection1;
		uniform float _NormalPanSpeed1;
		uniform float _NormalTile;
		uniform float _NormalStrength;
		uniform float _NormalPanSpeed2;
		uniform float2 _NormalPanDirection2;
		uniform float4 _WaterColor;
		uniform float4 _TopColor;
		uniform sampler2D _EdgeFoamTexture;
		uniform float _SeaFoamTile;
		uniform float _FoamMask;
		uniform float _SeaFoamStrength;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _EdgeDistance;
		uniform float _EdgeFoamTile;
		uniform float _EdgePower;
		uniform float _Tesselation;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_4 = (_Tesselation).xxxx;
			return temp_cast_4;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float3 break107 = float3(0,1,0);
			float4 appendResult109 = (float4(break107.x , ( break107.y * _WaveUp_Y ) , break107.z , 0.0));
			float temp_output_44_0 = ( _Time.y * _WaveFrequency );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float4 appendResult48 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float4 WorldSpaceTile50 = appendResult48;
			float4 WaveTileUV62 = ( ( WorldSpaceTile50 * float4( _WaveStretch, 0.0 , 0.0 ) ) * _WaveTileSize );
			float2 panner39 = ( temp_output_44_0 * _WaveDirectionSpeed + WaveTileUV62.xy);
			float simplePerlin2D38 = snoise( panner39 );
			simplePerlin2D38 = simplePerlin2D38*0.5 + 0.5;
			float2 panner65 = ( temp_output_44_0 * _WaveDirectionSpeed + ( WaveTileUV62 * float4( 0.1,0.1,0,0 ) ).xy);
			float simplePerlin2D66 = snoise( panner65 );
			simplePerlin2D66 = simplePerlin2D66*0.5 + 0.5;
			float WavePattern71 = ( simplePerlin2D38 + simplePerlin2D66 );
			float4 WaveHeight74 = ( ( appendResult109 * _WaveHeight ) * WavePattern71 );
			v.vertex.xyz += WaveHeight74.xyz;
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_worldPos = i.worldPos;
			float4 appendResult48 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float4 WorldSpaceTile50 = appendResult48;
			float temp_output_140_0 = ( _NormalTile / 10.0 );
			float4 temp_output_116_0 = ( WorldSpaceTile50 * temp_output_140_0 );
			float2 panner121 = ( 1.0 * _Time.y * ( ( _NormalPanDirection1 * _NormalPanSpeed1 ) / float2( 10,10 ) ) + temp_output_116_0.xy);
			float2 panner122 = ( 1.0 * _Time.y * ( ( _NormalPanSpeed2 * _NormalPanDirection2 ) / float2( 10,10 ) ) + ( temp_output_116_0 * ( temp_output_140_0 * 5.0 ) ).xy);
			float3 Normals137 = BlendNormals( UnpackScaleNormal( tex2D( _NormalMap, panner121 ), _NormalStrength ) , UnpackScaleNormal( tex2D( _NormalMap, panner122 ), _NormalStrength ) );
			o.Normal = Normals137;
			float simplePerlin2D163 = snoise( ( WorldSpaceTile50 * _FoamMask ).xy );
			simplePerlin2D163 = simplePerlin2D163*0.5 + 0.5;
			float clampResult170 = clamp( ( tex2D( _EdgeFoamTexture, ( ( WorldSpaceTile50 / 10.0 ) * _SeaFoamTile ).xy ).r * simplePerlin2D163 ) , 0.0 , 1.0 );
			float SeaFoam159 = clampResult170;
			float temp_output_44_0 = ( _Time.y * _WaveFrequency );
			float4 WaveTileUV62 = ( ( WorldSpaceTile50 * float4( _WaveStretch, 0.0 , 0.0 ) ) * _WaveTileSize );
			float2 panner39 = ( temp_output_44_0 * _WaveDirectionSpeed + WaveTileUV62.xy);
			float simplePerlin2D38 = snoise( panner39 );
			simplePerlin2D38 = simplePerlin2D38*0.5 + 0.5;
			float2 panner65 = ( temp_output_44_0 * _WaveDirectionSpeed + ( WaveTileUV62 * float4( 0.1,0.1,0,0 ) ).xy);
			float simplePerlin2D66 = snoise( panner65 );
			simplePerlin2D66 = simplePerlin2D66*0.5 + 0.5;
			float WavePattern71 = ( simplePerlin2D38 + simplePerlin2D66 );
			float clampResult87 = clamp( WavePattern71 , 0.0 , 1.0 );
			float4 lerpResult85 = lerp( _WaterColor , ( _TopColor + ( SeaFoam159 * _SeaFoamStrength ) ) , clampResult87);
			float4 Albedo91 = lerpResult85;
			o.Albedo = Albedo91.rgb;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth95 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth95 = abs( ( screenDepth95 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _EdgeDistance ) );
			float clampResult103 = clamp( ( ( ( 1.0 - distanceDepth95 ) + tex2D( _EdgeFoamTexture, ( ( WorldSpaceTile50 / 10.0 ) * _EdgeFoamTile ).xy ).r ) * _EdgePower ) , 0.0 , 1.0 );
			float Edge100 = clampResult103;
			float3 temp_cast_9 = (Edge100).xxx;
			o.Emission = temp_cast_9;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
1913;143;1920;868;2760.655;1173.625;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;52;-3555.362,-1636.189;Inherit;False;866.4834;316.7064;World Space UVs - Proyectar UVs en el mundo;3;48;47;50;World Space UVs;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;47;-3505.362,-1586.189;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;48;-3204.878,-1573.482;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;63;-3926.161,-1273.551;Inherit;False;1236.072;608.4144;Wave Tile UV - Transformamos las UVs de WorldSpace y modificamos valores de tamaño en X e Y.;6;54;56;58;55;57;62;Wave Tile UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-2917.879,-1579.482;Inherit;False;WorldSpaceTile;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;56;-3876.161,-1010.506;Inherit;False;Property;_WaveStretch;WaveStretch;0;0;Create;True;0;0;0;False;0;False;33,0.04;0.07,0.02;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;54;-3872.593,-1223.552;Inherit;False;50;WorldSpaceTile;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;173;-887.6392,-1657.322;Inherit;False;2053.858;550.5253;Sea Foam;13;166;153;165;157;154;156;163;155;158;171;159;176;177;Sea Foam;0.7445265,0.9339623,0.9008754,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;55;-3555.159,-1158.81;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;58;-3549.256,-924.1382;Inherit;False;Property;_WaveTileSize;Wave Tile Size;1;0;Create;True;0;0;0;False;0;False;0;0.83;0.1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;101;-913.4721,-2583.95;Inherit;False;2735.74;810.8219;Edge where water intersects object;9;150;99;100;103;98;97;95;96;151;Edge;0.3426486,0.9098868,0.9433962,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;-3261.162,-1157.81;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;157;-767.9626,-1473.322;Inherit;False;Constant;_Float1;Float 1;20;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;153;-785.9623,-1607.322;Inherit;False;50;WorldSpaceTile;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;151;-895.6994,-2266.796;Inherit;False;1248.406;464.8752;Edge Foam;7;149;148;145;147;144;143;146;Edge Foam;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;154;-454.9622,-1586.322;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;156;-301.9612,-1473.322;Inherit;False;Property;_SeaFoamTile;Sea Foam Tile;21;0;Create;True;0;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;166;-837.6392,-1242.797;Inherit;False;Property;_FoamMask;FoamMask;22;0;Create;True;0;0;0;False;0;False;0;0.0572;0;0.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;76;-2979.583,-336.8724;Inherit;False;2078.186;1167.115;Wave Pattern;13;69;71;38;66;39;65;44;67;64;41;70;43;45;Wave Pattern;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;62;-2914.09,-1148.588;Inherit;False;WaveTileUV;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;165;-559.6392,-1273.797;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleTimeNode;43;-2896.565,288.8312;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;143;-371.2379,-2216.796;Inherit;True;Property;_EdgeFoamTexture;EdgeFoamTexture;19;0;Create;True;0;0;0;False;0;False;None;03d06a383a0ba74418a4a05d2973ecc3;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;155;-95.96082,-1574.322;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-2888.768,512.4294;Inherit;False;Property;_WaveFrequency;WaveFrequency;3;0;Create;True;0;0;0;False;0;False;0.85;0.316;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;70;-2418.393,577.1138;Inherit;False;62;WaveTileUV;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;171;440.7198,-1443.859;Inherit;False;373.6536;209;Avoid overlap;2;169;170;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;163;-84.63916,-1265.797;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;-2650.863,317.4313;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;41;-2897.864,10.63249;Inherit;False;Property;_WaveDirectionSpeed;WaveDirectionSpeed;4;0;Create;True;0;0;0;False;0;False;1,0;0.2,0.2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;64;-2929.583,-286.8724;Inherit;False;62;WaveTileUV;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;158;115.3207,-1592.607;Inherit;True;Property;_TextureSample4;Texture Sample 4;22;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;138;-3017.901,959.8542;Inherit;False;2647.06;1456.335;Normal Map;24;126;125;112;118;129;122;128;120;127;130;131;113;121;124;117;115;123;114;116;132;137;140;141;142;Normal Map;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-2197.439,576.243;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.1,0.1,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;77;-2177.183,-1000.219;Inherit;False;1249.286;610.9183;WaveHeight;10;73;72;61;60;75;74;106;107;108;109;Wave Height;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;145;-858.7374,-2020.955;Inherit;False;50;WorldSpaceTile;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;39;-2256.324,-264.1859;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;117;-2933.615,1254.115;Inherit;False;Property;_NormalTile;Normal Tile;14;0;Create;True;0;0;0;False;0;False;1;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;65;-1932.76,272.0566;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;169;490.7198,-1387.99;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;149;-789.7375,-1892.955;Inherit;False;Constant;_Float0;Float 0;20;0;Create;True;0;0;0;False;0;False;10;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;140;-2764.085,1272.427;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;147;-374.7358,-1886.955;Inherit;False;Property;_EdgeFoamTile;Edge Foam Tile;20;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;128;-2332.809,1342.846;Inherit;False;Property;_NormalPanSpeed1;Normal Pan Speed 1;18;0;Create;True;0;0;0;False;0;False;1;0.213;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;93;-845.7918,-987.2607;Inherit;False;1289.627;1194.059;Albedo;9;91;85;82;84;94;160;162;174;175;Albedo;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;130;-2302.246,1889.369;Inherit;False;Property;_NormalPanSpeed2;Normal Pan Speed 2;13;0;Create;True;0;0;0;False;0;False;3;0.184;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;125;-2274.818,1188.769;Inherit;False;Property;_NormalPanDirection1;Normal Pan Direction 1;16;0;Create;True;0;0;0;False;0;False;1,0;1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleDivideOpNode;148;-527.7366,-1999.955;Inherit;False;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-508.0746,-2509.465;Inherit;False;Property;_EdgeDistance;Edge Distance;9;0;Create;True;0;0;0;False;0;False;1;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;126;-2127.619,2109.189;Inherit;False;Property;_NormalPanDirection2;Normal Pan Direction 2;17;0;Create;True;0;0;0;False;0;False;-1,0;-1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NoiseGeneratorNode;38;-1840.29,-129.7454;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;66;-1650.96,268.8566;Inherit;False;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;60;-2153.519,-952.2185;Inherit;False;Constant;_WaveUp;WaveUp;3;0;Create;True;0;0;0;False;0;False;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;115;-2891.932,1009.854;Inherit;False;50;WorldSpaceTile;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;170;643.3734,-1393.859;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;118;-2612.498,1743.857;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;129;-1895.394,1884.191;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-2157.82,-767.1882;Inherit;False;Property;_WaveUp_Y;WaveUp_Y;11;0;Create;True;0;0;0;False;0;False;34.3;29.2;1;40;0;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;107;-1988.284,-920.3387;Inherit;False;FLOAT3;1;0;FLOAT3;0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;146;-168.7358,-1987.955;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-1356.48,96.1258;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;95;-179.5783,-2518.643;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;-1922.469,1192.796;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;159;942.2185,-1575.21;Inherit;False;SeaFoam;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;-2582.218,1107.438;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;162;-790.208,-595.4836;Inherit;False;245;166;Sea Foam;1;161;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;141;-1752.297,1293.138;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;10,10;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;94;-822.7916,-358.2648;Inherit;False;439.7189;209;Quitar oscurecimientos raros;2;87;86;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-2316.342,1713.996;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;161;-744.208,-545.4836;Inherit;False;159;SeaFoam;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-1125.396,91.44763;Inherit;False;WavePattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;144;-3.363546,-2211.555;Inherit;True;Property;_TextureSample3;Texture Sample 3;20;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;175;-795.8571,-470.1915;Inherit;False;Property;_SeaFoamStrength;Sea Foam Strength;23;0;Create;True;0;0;0;False;0;False;0.1;0.3600588;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;142;-1736.297,1851.138;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;10,10;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;112;-2967.901,1629.056;Inherit;True;Property;_NormalMap;NormalMap;12;0;Create;True;0;0;0;False;0;False;None;24e31ecbf813d9e49bf7a1e0d4034916;True;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-1836.284,-903.3387;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;97;82.02345,-2504.064;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;150;388.0694,-2501.502;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;84;-795.7917,-772.2619;Inherit;False;Property;_TopColor;TopColor;8;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.4251958,0.8073246,0.8584906,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;121;-1644.798,1099.992;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-771.7916,-299.2001;Inherit;False;71;WavePattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;123;-1866.692,1604.126;Inherit;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-1552.769,1386.14;Inherit;False;Property;_NormalStrength;Normal Strength;15;0;Create;True;0;0;0;False;0;False;0;0.56;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;122;-1609.283,1703.193;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;124;-1870.013,1524.43;Inherit;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.DynamicAppendNode;109;-1694.82,-937.1882;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;72;-2127.181,-648.3002;Inherit;False;Property;_WaveHeight;WaveHeight;5;0;Create;True;0;0;0;False;0;False;1;0.127;0;0.3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;99;504.8085,-2364.775;Inherit;False;Property;_EdgePower;Edge Power;10;0;Create;True;0;0;0;False;0;False;0;0.562;0;0.9;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;174;-487.8571,-524.1915;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;82;-795.7917,-937.2607;Inherit;False;Property;_WaterColor;WaterColor;7;0;Create;True;0;0;0;False;0;False;0,0,0,0;0.135858,0.5008987,0.6698113,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;98;835.3951,-2497.974;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;160;-466.208,-731.4836;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;113;-1224.678,1282.157;Inherit;True;Property;_TextureSample1;Texture Sample 1;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;75;-1653.927,-643.0914;Inherit;False;71;WavePattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;87;-554.0727,-308.2648;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;114;-1232.374,1507.681;Inherit;True;Property;_TextureSample2;Texture Sample 2;13;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-1542.877,-808.9697;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;103;1076.915,-2499.199;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;85;-285.7918,-857.261;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendNormalsNode;131;-878.2874,1373.376;Inherit;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;73;-1390.71,-681.4199;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;91;88.45974,-816.6575;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;74;-1151.893,-681.3569;Inherit;False;WaveHeight;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;100;1396.276,-2492.941;Inherit;False;Edge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;137;-594.8404,1363.284;Inherit;False;Normals;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;78;2952.508,669.2322;Inherit;False;74;WaveHeight;1;0;OBJECT;;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;80;1248.998,-878.5528;Inherit;True;Property;_TextureSample0;Texture Sample 0;6;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;5b653e484c8e303439ef414b62f969f0;True;1;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;111;1331.019,-690.7458;Inherit;False;71;WavePattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;2946.236,577.0944;Inherit;False;Constant;_Smoothness;Smoothness;7;0;Create;True;0;0;0;False;0;False;0.9;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;177;661.574,-1213.003;Inherit;False;71;WavePattern;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;176;873.2489,-1381.995;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;92;2941.479,319.4306;Inherit;False;91;Albedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;1623.02,-822.746;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;139;2948.522,412.8144;Inherit;False;137;Normals;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;59;2872.584,752.284;Inherit;False;Property;_Tesselation;Tesselation;2;0;Create;True;0;0;0;False;0;False;5;8.82;0.1;15;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;102;2941.516,502.1121;Inherit;False;100;Edge;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;3153.354,386.8234;Float;False;True;-1;6;ASEMaterialInspector;0;0;Lambert;WaterIsland;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;48;0;47;1
WireConnection;48;1;47;3
WireConnection;50;0;48;0
WireConnection;55;0;54;0
WireConnection;55;1;56;0
WireConnection;57;0;55;0
WireConnection;57;1;58;0
WireConnection;154;0;153;0
WireConnection;154;1;157;0
WireConnection;62;0;57;0
WireConnection;165;0;153;0
WireConnection;165;1;166;0
WireConnection;155;0;154;0
WireConnection;155;1;156;0
WireConnection;163;0;165;0
WireConnection;44;0;43;0
WireConnection;44;1;45;0
WireConnection;158;0;143;0
WireConnection;158;1;155;0
WireConnection;67;0;70;0
WireConnection;39;0;64;0
WireConnection;39;2;41;0
WireConnection;39;1;44;0
WireConnection;65;0;67;0
WireConnection;65;2;41;0
WireConnection;65;1;44;0
WireConnection;169;0;158;1
WireConnection;169;1;163;0
WireConnection;140;0;117;0
WireConnection;148;0;145;0
WireConnection;148;1;149;0
WireConnection;38;0;39;0
WireConnection;66;0;65;0
WireConnection;170;0;169;0
WireConnection;118;0;140;0
WireConnection;129;0;130;0
WireConnection;129;1;126;0
WireConnection;107;0;60;0
WireConnection;146;0;148;0
WireConnection;146;1;147;0
WireConnection;69;0;38;0
WireConnection;69;1;66;0
WireConnection;95;0;96;0
WireConnection;127;0;125;0
WireConnection;127;1;128;0
WireConnection;159;0;170;0
WireConnection;116;0;115;0
WireConnection;116;1;140;0
WireConnection;141;0;127;0
WireConnection;120;0;116;0
WireConnection;120;1;118;0
WireConnection;71;0;69;0
WireConnection;144;0;143;0
WireConnection;144;1;146;0
WireConnection;142;0;129;0
WireConnection;106;0;107;1
WireConnection;106;1;108;0
WireConnection;97;0;95;0
WireConnection;150;0;97;0
WireConnection;150;1;144;1
WireConnection;121;0;116;0
WireConnection;121;2;141;0
WireConnection;123;0;112;0
WireConnection;122;0;120;0
WireConnection;122;2;142;0
WireConnection;124;0;112;0
WireConnection;109;0;107;0
WireConnection;109;1;106;0
WireConnection;109;2;107;2
WireConnection;174;0;161;0
WireConnection;174;1;175;0
WireConnection;98;0;150;0
WireConnection;98;1;99;0
WireConnection;160;0;84;0
WireConnection;160;1;174;0
WireConnection;113;0;124;0
WireConnection;113;1;121;0
WireConnection;113;5;132;0
WireConnection;87;0;86;0
WireConnection;114;0;123;0
WireConnection;114;1;122;0
WireConnection;114;5;132;0
WireConnection;61;0;109;0
WireConnection;61;1;72;0
WireConnection;103;0;98;0
WireConnection;85;0;82;0
WireConnection;85;1;160;0
WireConnection;85;2;87;0
WireConnection;131;0;113;0
WireConnection;131;1;114;0
WireConnection;73;0;61;0
WireConnection;73;1;75;0
WireConnection;91;0;85;0
WireConnection;74;0;73;0
WireConnection;100;0;103;0
WireConnection;137;0;131;0
WireConnection;176;1;170;0
WireConnection;176;2;177;0
WireConnection;110;0;80;0
WireConnection;110;1;111;0
WireConnection;0;0;92;0
WireConnection;0;1;139;0
WireConnection;0;2;102;0
WireConnection;0;11;78;0
WireConnection;0;14;59;0
ASEEND*/
//CHKSM=37B8BC4AAE4E43B79F43A1A03DC723A6D2EF4436