﻿Shader "Custom/ScrollingUVs"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_ScrollXSpeed("X Scroll Speed",Range(0,10)) = 2
		_ScrollYSpeed("Y Scroll Speed",Range(0,10)) = 2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;
		fixed _ScrollXSpeed, _ScrollYSpeed;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			fixed2 scrolledUV = IN.uv_MainTex;
			fixed xScrollValue = _ScrollXSpeed * _Time;
			fixed yScrollValue = _ScrollYSpeed * _Time;

			scrolledUV += fixed2(xScrollValue, yScrollValue);

            fixed4 c = tex2D (_MainTex, scrolledUV);
			o.Albedo = c.rgb * _Color;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
