Shader "Custom/OptimizedShader02"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BlendTex("Blend Tex",2D) = "white"{}
		_BumpMap("Normal Map",2D) = "bump"{}
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }

		CGPROGRAM
		#pragma surface surf Standard fullforwardshadows
		#pragma target 3.0

		sampler2D _MainTex,_BlendTex,_BumpMap;

        struct Input
        {
			float2 uv_MainTex, uv_BlendTex, uv_BumpMap;
        };


        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			fixed4 blendTex = tex2D(_BlendTex, IN.uv_MainTex);
			c = lerp(c, blendTex, blendTex.r);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
        }
        ENDCG
    }
    FallBack "Diffuse"
}
