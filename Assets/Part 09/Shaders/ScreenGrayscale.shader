Shader "Custom/ScreenGrayscale"
{
	Properties
	{
		  _MainTex("Base (RGB)",2D) = "white"{}
		_Luminosity("Luminosity",Range(0,1)) = 1
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
						fixed _Luminosity;

						fixed4 frag(v2f_img i) :COLOR
						{
							//렌더 텍스쳐로부터 색상을,v2f_img로부터 uv를 얻는다
							fixed4 renderTex = tex2D(_MainTex,i.uv);
							half luminosity = 0.299 * renderTex.r + 0.587 * renderTex.g + 0.114 * renderTex.b;
							fixed4 finalColor = lerp(renderTex, luminosity, _Luminosity);
							renderTex.rgb = finalColor;
							return renderTex;
						}
							ENDCG
					}
		}
			FallBack off
}
