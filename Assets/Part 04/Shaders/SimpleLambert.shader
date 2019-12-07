Shader "Custom/SimpleLambert"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma surface surf SimpleLambert
		#pragma target 3.0

		sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
        }

		half4 LightingSimpleLambert(SurfaceOutput s, half3 lightDir, half atten)
		{
			half NdotL = dot(s.Normal, lightDir);
			half4 color;
			color.rgb = s.Albedo * _LightColor0.rgb * (NdotL * atten);
			color.a = s.Alpha;

			return color;
		}

        ENDCG
    }
    FallBack "Diffuse"
}
