Shader "Custom/ScreenBSC"
{
	Properties
	{
		_MainTex("Base (RGB)",2D) = "white"{}
		_Brightness("Brightness",Range(0.0,1)) = 1.0
		_Saturation("Saturation",Range(0.0,1)) = 1.0
		_Contrast("Contrast",Range(0.0,1)) = 1.0
	}
		SubShader
		{
				Pass
					{
						CGPROGRAM
						#pragma vertex vert_img
						#pragma fragment frag
						#pragma fragmentoption ARB_precision_hint_fastest
						#include "UnityCG.cginc"

						uniform sampler2D _MainTex;
						half _Brightness, _Saturation, _Contrast;

						half3 ContrastSaturationBrightness(half3 color, half brt, half sat, half con)
						{
							//R,G,B 색상 채널을 각각 조절하기 위해 아래 값을 조절한다
							half AvgLumR = 0.5, AvgLumG = 0.5, AvgLumB = 0.5;

							//이미지에서 광도를 얻기 위한 광도 계수
							half3 LuminanceCoeff = fixed3(0.2125, 0.7154, 0.0721);

							//밝기 연산
							half3 AvgLumin = fixed3(AvgLumR, AvgLumG, AvgLumB);
							half3 brtColor = color * brt;
							half intensityf = dot(brtColor, LuminanceCoeff);
							half3 intensity = fixed3(intensityf, intensityf, intensityf);
							//채도 연산
							half3 satColor = lerp(intensity, brtColor, sat);
							//대비 연산
							half3 conColor = lerp(AvgLumin, satColor, con);
							return conColor;
						}

						fixed4 frag(v2f_img i) :COLOR
						{
							fixed4 renderTex = tex2D(_MainTex,i.uv);
						//밝기, 채도, 대비 작업 적용
						renderTex.rgb = ContrastSaturationBrightness(renderTex.rgb, _Brightness, _Saturation, _Contrast);
						return renderTex;
					}
						ENDCG
				}
		}
			FallBack off
}