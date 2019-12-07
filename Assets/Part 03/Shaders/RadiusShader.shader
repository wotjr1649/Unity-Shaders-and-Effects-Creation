Shader "Custom/RadiusShader"
{
	Properties
	{
		_MainTex("MainTex",2D) = "white"{}
		_Center("Center",Vector) = (200,0,200,0)
		_Radius("Radius",Float) = 100
		_RadiusColor("Radius Color",Color) = (1,0,0,1)
		_RadiusWidth("Radius Width",Float) = 10
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }

			CGPROGRAM
			#pragma surface surf Standard fullforwardshadows
			#pragma target 3.0

		sampler2D _MainTex;
	half3 _Center;
	half4 _RadiusColor;
	half _Radius, _RadiusWidth;

		struct Input
		{
			float2 uv_MainTex;
			float3 worldPos;
		};

		fixed4 _Color;

		UNITY_INSTANCING_BUFFER_START(Props)
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			float d = distance(_Center, IN.worldPos);
			o.Albedo = ((d > _Radius) && (d < _Radius + _RadiusWidth)) ? _RadiusColor : tex2D(_MainTex, IN.uv_MainTex).rgb;
		}
		ENDCG
		}
			FallBack "Diffuse"
}
