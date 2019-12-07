Shader "Custom/OptimizedShader01"
{
    Properties
	{
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_BumpMap("Normal Map",2D) = "bump"{}
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma surface surf SimpleLambert exclude_path:prepass noforwardadd

		sampler2D _MainTex,_BumpMap;

        struct Input
        {
			half2 uv_MainTex;
        };


        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }

		inline fixed4 LightingSimpleLambert(SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten)
		{
			fixed diff = max(0, dot(s.Normal, lightDir));
			fixed4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * (diff * atten * 2);
			c.a = s.Alpha;
			return c;
		}

        ENDCG
    }
    FallBack "Diffuse"
}
