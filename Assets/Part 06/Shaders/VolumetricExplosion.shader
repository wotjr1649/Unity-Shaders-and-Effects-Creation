Shader "Custom/VolumetricExplosion"
{
    Properties
    {
		_RampTex("Color Ramp",2D) = "white"{}
		_RampOffset("Ramp Offset",Range(-0.5,0.5)) = 0
		_NoiseTex("Noise Texture",2D) = "gray"{}
		_Period("Period",Range(0,1)) = 0.5
		_Amount("Amount",Range(0,1)) = 0.1
		_ClipRange("ClipRange",Range(0,1)) = 1
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }

			CGPROGRAM
			#pragma surface surf Standard vertex:vert nolightmap
			#pragma target 3.0

			sampler2D _RampTex, _NoiseTex;
			half _RampOffset, _Period, _Amount, _ClipRange;

        struct Input
        {
			float2 uv_NoiseTex;
        };

		void vert(inout appdata_full v)
		{
			half3 disp = tex2Dlod(_NoiseTex, half4(v.texcoord.xy, 0, 0));
			half time = sin(_Time[3] * _Period + disp.r * 10);
			v.vertex.xyz += v.normal * disp.r * _Amount * time;
		}

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			half3 noise = tex2D(_NoiseTex, IN.uv_NoiseTex);
			half n = saturate(noise.r + _RampOffset);
			clip(_ClipRange - n);
			half4 c = tex2D(_RampTex, half2(n, 0.5));
			o.Albedo = c.rgb;
			o.Emission = c.rgb * c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
