Shader "Custom/ScreenOldFilm"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_VignetteTex("Vignette Texture",2D) = "white"{}
		_ScratchesTex("Scratches Texture",2D) = "white"{}
		_DustTex("Dust Texture",2D) = "white"{}
		_SepiaColor("Sepia Color",Color)=(1,1,1,1)
			_EffectAmount("Old Film Effect Amount",Range(0,1))=1.0
			_VignetteAmount("Vignette Opacity",Range(0,1))=1.0
			_ScratchesYSpeed("Scratches Y Speed",Float)=10.0
			_ScratchesYSpeed("Scratches X Speed",Float)=10.0
			_dustYSpeed("Dust Y Speed",Float)=10.0
			_dustXSpeed("Dust X Speed",Float)=10.0



    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
