Shader "Custom/BlinnPhong"
{
    Properties
    {
		_MainTint("Diffuse Tint",Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_SpecularColor("Specular Color",Color) = (1,1,1,1)
		_SpecPower("Specular Power", Range(0.1, 60)) = 3

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf CustomBlinnPhong
        #pragma target 3.0

		sampler2D _MainTex;
		half4 _SpecularColor, _MainTint;
		half _SpecPower;

        struct Input
        {
            float2 uv_MainTex;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _MainTint;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

		half4 LightingCustomBlinnPhong(SurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
		{
			half NdotL = saturate(dot(s.Normal, lightDir));

			half3 halfVector = normalize(lightDir + viewDir);
			half  NdotH = saturate(dot(s.Normal, halfVector));
			half spec = pow(NdotH, _SpecPower) * _SpecularColor;

			half4 color;
			color.rgb = s.Albedo * _LightColor0.rgb * NdotL + _LightColor0.rgb * _SpecularColor.rgb * spec * atten;
			color.a = s.Alpha;
			return color;
		}

        ENDCG
    }
    FallBack "Diffuse"
}
