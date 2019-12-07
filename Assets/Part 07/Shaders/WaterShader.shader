Shader "Custom/WaterShader"
{
	Properties
	{
		_NoiseTex("Noise Tex",2D) = "white"{}
		_Colour("Colour",Color) = (1,1,1,1)
		_Period("Period",Range(0,50)) = 1
		_Magnitude("Magnitude",Range(0,0.5)) = 0.05
		_Scale("Scale",Range(0,10)) = 1
	}
		SubShader
		{
			Tags{"Queue" = "Transparent"}
			GrabPass{}
			Pass
				{
					CGPROGRAM
						#pragma vertex vert
						#pragma fragment frag
						#include "UnityCG.cginc"

						sampler2D _GrabTexture,_NoiseTex;
						half4 _Colour;
						half _Period, _Magnitude, _Scale;

						struct vertInput
						{
							half4 vertex:POSITION;
							fixed4 color : COLOR;
							half2 texcoord:TEXCOORD0;
						};

						struct vertOutput
						{
							half4 vertex:POSITION;
							fixed4 color : COLOR;
							half2 texcoord:TEXCOORD0;
							half4 worldPos:TEXCOORD1;
							half4 uvgrab:TEXCOORD2;
						};

						vertOutput vert(vertInput v)
						{
							vertOutput o;
							o.vertex = UnityObjectToClipPos(v.vertex);
							o.color = v.color;
							o.texcoord = v.texcoord;

							o.worldPos = mul(unity_ObjectToWorld, v.vertex);
							o.uvgrab = ComputeGrabScreenPos(o.vertex);
							return o;
						}

						half4 frag(vertOutput i) :COLOR
						{
							half sinT = sin(_Time.w / _Period);
							half distX = tex2D(_NoiseTex, i.worldPos.xy / _Scale + half2(sinT, 0)).r - 0.5;
							half distY = tex2D(_NoiseTex, i.worldPos.xy / _Scale + half2(0, sinT)).r - 0.5;

							half2 distortion = half2(distX, distY);
							i.uvgrab.xy += distortion * _Magnitude;
							half4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
							return col * _Colour;
						}
							ENDCG
				}
		}
			FallBack "Diffuse"
}
