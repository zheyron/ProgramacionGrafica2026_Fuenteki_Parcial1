// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Dissolve_UI"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_DissolveAmount("DissolveAmount", Range( 0 , 1)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _DissolveAmount;
		uniform float _Cutoff = 0.5;


		float2 voronoihash4( float2 p )
		{
			
			p = float2( dot( p, float2( 127.1, 311.7 ) ), dot( p, float2( 269.5, 183.3 ) ) );
			return frac( sin( p ) *43758.5453);
		}


		float voronoi4( float2 v, float time, inout float2 id, inout float2 mr, float smoothness )
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
			 		float2 o = voronoihash4( n + g );
					o = ( sin( time + o * 6.2831 ) * 0.5 + 0.5 ); float2 r = f - g - o;
					float d = 0.5 * dot( r, r );
			 //		if( d<F1 ) {
			 //			F2 = F1;
			 			float h = smoothstep(0.0, 1.0, 0.5 + 0.5 * (F1 - d) / smoothness); F1 = lerp(F1, d, h) - smoothness * h * (1.0 - h);mg = g; mr = r; id = o;
			 //		} else if( d<F2 ) {
			 //			F2 = d;
			 //		}
			 	}
			}
			return F1;
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Alpha = 1;
			float time4 = 1.0;
			float voronoiSmooth0 = 0.0;
			float2 coords4 = i.uv_texcoord * 5.0;
			float2 id4 = 0;
			float2 uv4 = 0;
			float fade4 = 0.5;
			float voroi4 = 0;
			float rest4 = 0;
			for( int it4 = 0; it4 <4; it4++ ){
			voroi4 += fade4 * voronoi4( coords4, time4, id4, uv4, voronoiSmooth0 );
			rest4 += fade4;
			coords4 *= 2;
			fade4 *= 0.5;
			}//Voronoi4
			voroi4 /= rest4;
			clip( ( (0.0 + (( 1.0 - _DissolveAmount ) - 0.0) * (1.0 - 0.0) / (1.0 - 0.0)) + voroi4 ) - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
0;73;944;535;1445.677;313.6639;1.341591;True;False
Node;AmplifyShaderEditor.RangedFloatNode;2;-1021.884,44.41373;Inherit;False;Property;_DissolveAmount;DissolveAmount;1;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;7;-784.4927,13.73952;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VoronoiNode;4;-611.1183,395.1649;Inherit;False;0;0;1;0;4;False;1;False;True;4;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;5;False;3;FLOAT;0;False;3;FLOAT;0;FLOAT2;1;FLOAT2;2
Node;AmplifyShaderEditor.TFHCRemapNode;6;-527.0976,-54.27693;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;-284.3723,177.7791;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;1;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Dissolve_UI;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;2;0
WireConnection;6;0;7;0
WireConnection;5;0;6;0
WireConnection;5;1;4;0
WireConnection;1;10;5;0
ASEEND*/
//CHKSM=87CA1AE2DE979D156C6683726FEF18B10306B760