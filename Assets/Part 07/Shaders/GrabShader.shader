// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/GrabShader"
{
		SubShader
	{
		Tags{"Queue" = "Transparent"}
		GrabPass{}
		Pass
	{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		sampler2D _GrabTexture;

		struct vertInput
		{
			float4 vertex : POSITION;
		};

		struct vertOutput
		{
			float4 vertex : POSITION;
			float4 uvgrab : TEXCOORD1;
		};

		//정점함수
		vertOutput vert(vertInput v)
		{
			vertOutput o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.uvgrab = ComputeGrabScreenPos(o.vertex);
			return o;
		}

		//프래그먼트 함수
		half4 frag(vertOutput i) : COLOR
		{
			fixed4 col = tex2Dproj(_GrabTexture,UNITY_PROJ_COORD(i.uvgrab));
		return col + half4(0.5, 0, 0, 0);
		}
			ENDCG
	}
		
	}
		FallBack "Diffuse"
}
