// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Edificio"
{
	Properties
	{
		_BrickColorTex("BrickColorTex", 2D) = "white" {}
		_BrickAlbedo("BrickAlbedo", Color) = (0.3396226,0.2158052,0.1906372,0)
		_DirtTex("DirtTex", 2D) = "white" {}
		_DirtAlbedo("DirtAlbedo", Color) = (1,1,1,0)
		_DirtScale("DirtScale", Float) = 1
		_LowBorderTex("LowBorderTex", 2D) = "white" {}
		_LowBorderAlbedo("LowBorderAlbedo", Color) = (1,1,1,0)
		_LowBorderTexScale("LowBorderTexScale", Vector) = (0,0,0,0)
		_LowBorderDistance("LowBorderDistance", Float) = 0
		_Vector0("Vector 0", Vector) = (1,1,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
		};

		uniform sampler2D _DirtTex;
		uniform float2 _Vector0;
		uniform float4 _DirtAlbedo;
		uniform float _DirtScale;
		uniform sampler2D _BrickColorTex;
		uniform float4 _BrickAlbedo;
		uniform float _LowBorderDistance;
		uniform sampler2D _LowBorderTex;
		uniform float2 _LowBorderTexScale;
		uniform float4 _LowBorderAlbedo;


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


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 UVs61 = ( i.uv_texcoord / _Vector0 );
			float simplePerlin2D5 = snoise( float2( 0,0 )*_DirtScale );
			simplePerlin2D5 = simplePerlin2D5*0.5 + 0.5;
			float smoothstepResult7 = smoothstep( 0.7 , 1.0 , simplePerlin2D5);
			float clampResult11 = clamp( smoothstepResult7 , -1.0 , 1.0 );
			float DirtNoise13 = clampResult11;
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float LowBorder27 = step( ase_vertex3Pos.y , _LowBorderDistance );
			float2 LowBorderScaledUVs12 = ( i.uv_texcoord / _LowBorderTexScale );
			float4 ALBEDO47 = ( ( tex2D( _DirtTex, UVs61 ) * _DirtAlbedo * DirtNoise13 ) + ( ( ( tex2D( _BrickColorTex, UVs61 ) * _BrickAlbedo * ( 1.0 - DirtNoise13 ) ) * ( 1.0 - LowBorder27 ) ) + ( LowBorder27 * ( tex2D( _LowBorderTex, LowBorderScaledUVs12 ) * _LowBorderAlbedo * ( 1.0 - DirtNoise13 ) ) ) ) );
			o.Albedo = ALBEDO47.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
806;73;664;602;191.4811;-827.9217;1.3;True;False
Node;AmplifyShaderEditor.CommentaryNode;1;-1884.977,-1410.819;Inherit;False;3006.338;2071.785;ALBEDO;13;47;46;45;39;38;28;15;13;11;7;5;2;54;;0.7469271,0.3820755,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;2;-1840.42,-1103.057;Inherit;False;Property;_DirtScale;DirtScale;4;0;Create;True;0;0;0;False;0;False;1;1.75;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;4;-1605.108,-36.83655;Inherit;False;1785.337;944.786;Low Brick Border;5;43;14;10;48;67;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;55;-2850.47,-798.2167;Inherit;False;822.097;531.5579;UVs by World Position;4;61;60;64;68;;1,0.9995908,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;48;-1530.73,580.8239;Inherit;False;645.6021;294.1739;Low Border UVs;3;12;9;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;5;-1528.486,-1233.004;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;0.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;6;-1480.73,710.9977;Inherit;False;Property;_LowBorderTexScale;LowBorderTexScale;7;0;Create;True;0;0;0;False;0;False;0,0;3,0.3;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;10;-1494.762,4.906372;Inherit;False;876.1628;376.0577;Low Border Limit;4;27;22;17;16;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;67;-1495.36,499.3943;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexCoordVertexDataNode;64;-2687.099,-641.6101;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;68;-2554.136,-487.337;Inherit;False;Property;_Vector0;Vector 0;9;0;Create;True;0;0;0;False;0;False;1,1;1,0.1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SmoothstepOpNode;7;-1269.497,-1209.531;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.7;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;60;-2391.453,-626.5637;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;9;-1276.173,636.9268;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PosVertexDataNode;16;-1444.762,54.90637;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-1435.415,214.5094;Inherit;False;Property;_LowBorderDistance;LowBorderDistance;8;0;Create;True;0;0;0;False;0;False;0;-0.43;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;11;-1064.328,-1205.158;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;61;-2252.375,-618.5637;Inherit;False;UVs;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;15;-1051.184,-777.3702;Inherit;False;1176.823;459.2965;Brick Base Color;7;37;32;30;25;21;19;65;;0.509434,0.4194198,0.3676575,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-915.9102,-1205.339;Inherit;False;DirtNoise;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;14;-872.3212,422.1304;Inherit;False;839.8816;455.6223;Low Border Color;7;33;31;29;26;24;20;18;;1,1,1,1;0;0
Node;AmplifyShaderEditor.StepOpNode;22;-1214.086,126.9645;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;12;-1145.128,632.9442;Inherit;False;LowBorderScaledUVs;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-893.2147,-467.1183;Inherit;False;61;UVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;24;-822.3212,472.1304;Inherit;True;Property;_LowBorderTex;LowBorderTex;5;0;Create;True;0;0;0;False;0;False;None;30829d5dd88841546aba2990deee25a0;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;21;-397.8992,-444.7944;Inherit;False;13;DirtNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;27;-998.1761,132.4294;Inherit;False;LowBorder;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;19;-1001.185,-727.3699;Inherit;True;Property;_BrickColorTex;BrickColorTex;0;0;Create;True;0;0;0;False;0;False;None;30829d5dd88841546aba2990deee25a0;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.WireNode;20;-614.9722,675.6696;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;-515.7231,799.2575;Inherit;False;13;DirtNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;25;-703.4068,-727.2609;Inherit;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;28;-762.9712,-1360.819;Inherit;False;934.7296;468.974;Dirt;5;44;42;41;40;34;;0.3867925,0.3090428,0.2682005,1;0;0
Node;AmplifyShaderEditor.ColorNode;32;-632.3824,-530.0731;Inherit;False;Property;_BrickAlbedo;BrickAlbedo;1;0;Create;True;0;0;0;False;0;False;0.3396226,0.2158052,0.1906372,0;0.3396226,0.2158052,0.1906372,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;30;-210.1351,-442.0684;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;29;-327.9591,801.9836;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;31;-545.7002,472.7084;Inherit;True;Property;_TextureSample1;Texture Sample 1;7;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;38;14.39624,-249.8773;Inherit;False;27;LowBorder;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;26;-483.6731,642.1749;Inherit;False;Property;_LowBorderAlbedo;LowBorderAlbedo;6;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-36.36217,-726.643;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-194.4391,474.0284;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexturePropertyNode;34;-712.9713,-1310.819;Inherit;True;Property;_DirtTex;DirtTex;2;0;Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.GetLocalVarNode;66;-540.6094,-1052.123;Inherit;False;61;UVs;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.OneMinusNode;54;240.6803,-241.1763;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;18.22485,360.5444;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;40;-336.1621,-1086.561;Inherit;False;Property;_DirtAlbedo;DirtAlbedo;3;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;42;-61.76332,-1002.664;Inherit;False;13;DirtNoise;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;41;-409.2833,-1282.046;Inherit;True;Property;_TextureSample3;Texture Sample 3;5;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;358.5968,-513.6041;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;45;558.7625,-356.6233;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;44;3.28261,-1236.628;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;715.6666,-507.0752;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;47;889.5607,-511.5563;Inherit;False;ALBEDO;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;70;180.3189,1120.421;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;69;407.7489,1162.175;Inherit;True;Checkerboard;-1;;1;43dad715d66e03a4c8ad5f9564018081;0;4;1;FLOAT2;0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;FLOAT2;0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;50;1215.595,-142.5511;Inherit;False;47;ALBEDO;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1463.875,-110.5979;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Edificio;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;5;1;2;0
WireConnection;7;0;5;0
WireConnection;60;0;64;0
WireConnection;60;1;68;0
WireConnection;9;0;67;0
WireConnection;9;1;6;0
WireConnection;11;0;7;0
WireConnection;61;0;60;0
WireConnection;13;0;11;0
WireConnection;22;0;16;2
WireConnection;22;1;17;0
WireConnection;12;0;9;0
WireConnection;27;0;22;0
WireConnection;20;0;12;0
WireConnection;25;0;19;0
WireConnection;25;1;65;0
WireConnection;30;0;21;0
WireConnection;29;0;18;0
WireConnection;31;0;24;0
WireConnection;31;1;20;0
WireConnection;37;0;25;0
WireConnection;37;1;32;0
WireConnection;37;2;30;0
WireConnection;33;0;31;0
WireConnection;33;1;26;0
WireConnection;33;2;29;0
WireConnection;54;0;38;0
WireConnection;43;0;27;0
WireConnection;43;1;33;0
WireConnection;41;0;34;0
WireConnection;41;1;66;0
WireConnection;39;0;37;0
WireConnection;39;1;54;0
WireConnection;45;0;39;0
WireConnection;45;1;43;0
WireConnection;44;0;41;0
WireConnection;44;1;40;0
WireConnection;44;2;42;0
WireConnection;46;0;44;0
WireConnection;46;1;45;0
WireConnection;47;0;46;0
WireConnection;69;1;70;0
WireConnection;0;0;50;0
ASEEND*/
//CHKSM=3F3FF4B800C003E4468410C652A077B3AC16542D