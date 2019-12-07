Shader "Custom/ToonShaderLevels"
{
	Properties
	{
		_MainTex("MainTex",2D) = "white"{}
		_RampTex("Ramp",2D) = "white"{}
		_CelShadingLevels("LEVEL",Range(0,10)) = 1
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }

			CGPROGRAM
			#pragma surface surf Toon
			#pragma target 3.0

			sampler2D _RampTex,_MainTex;
			half _CelShadingLevels;

			struct Input
			{
				float2 uv_MainTex;
			};

			UNITY_INSTANCING_BUFFER_START(Props)
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutput o)
			{
				o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
			}

			half4 LightingToon(SurfaceOutput s, float3 lightDir, float atten)
			{
				half NdotL = dot(s.Normal, lightDir);
				half cel = floor(NdotL * _CelShadingLevels) / (_CelShadingLevels - 0.5);
				half4 color;
				color.rgb = s.Albedo * _LightColor0.rgb * (cel * atten);
				color.a = s.Alpha;
				return color;
			}

			ENDCG
		}
			FallBack "Diffuse"
}
