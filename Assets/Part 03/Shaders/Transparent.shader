Shader "Custom/Transparent"
{
	Properties
	{
		_Color("Color",Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
	}
		SubShader
	{
		Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		Cull Back

		CGPROGRAM
		#pragma surface surf Standard alpha:fade
		#pragma target 3.0

		sampler2D _MainTex;
		half4 _Color;

		struct Input
		{
			float2 uv_MainTex;
		};

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
		FallBack "Diffuse"
}
