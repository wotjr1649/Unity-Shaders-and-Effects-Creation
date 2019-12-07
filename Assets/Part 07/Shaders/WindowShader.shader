Shader "Custom/WindowShader"
{
	Properties
	{
		_MainTex("Base (RGB) Trans (A)",2D) = "white"{}
		_Colour("Colour",Color) = (1,1,1,1)
		_BumpMap("Noise Tex",2D) = "bump"{}
		_Magnitude("Magnitude",Range(0,1)) = 0.05
	}
		SubShader
		{
				Tags{"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Opaque"}
				GrabPass{}
				Pass
			{
				CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

				sampler2D _MainTex,_BumpMap,_GrabTexture;
				half4 _Colour;
				half _Magnitude;

				struct vertInput
				{
					float4 vertex : POSITION;
					half2 texcoord:TEXCOORD0;
				};
				struct vertOutput
				{
					float4 vertex : POSITION;
					half2 texcoord:TEXCOORD0;
					float4 uvgrab : TEXCOORD1;
				};
				vertOutput vert(vertInput v)
				{
					vertOutput o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uvgrab = ComputeGrabScreenPos(o.vertex);
					o.texcoord = v.texcoord;
					return o;
				}
				half4 frag(vertOutput i) :COLOR
				{
					half4 mainColour = tex2D(_MainTex,i.texcoord);
					half4 bump = tex2D(_BumpMap, i.texcoord);
					half2 distortion = UnpackNormal(bump).rg;
					i.uvgrab.xy += distortion * _Magnitude;
					half4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
					return col * mainColour * _Colour;
				}
					ENDCG
			}
		}
			FallBack "Diffuse"
}
