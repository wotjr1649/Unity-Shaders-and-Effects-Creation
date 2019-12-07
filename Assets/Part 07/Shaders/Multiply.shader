﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Multiply"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
	}
		SubShader
	{
		Pass
	{
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag

		half4 _Color;
	sampler2D _MainTex;

	struct vertInput
	{
		half4 pos:POSITION;
		half2 texcoord:TEXCOORD0;
	};

	struct vertOutput
	{
		half4 pos:SV_POSITION;
		half2 texcoord:TEXCOORD0;
	};

	vertOutput vert(vertInput input)
	{
		vertOutput o;
		o.pos = UnityObjectToClipPos(input.pos);
		o.texcoord = input.texcoord;
		return o;
	}

	half4 frag(vertOutput output) :COLOR
	{
		half4 mainColour = tex2D(_MainTex,output.texcoord);
		return mainColour * _Color;
	}
		ENDCG
	}
	}
		FallBack "Diffuse"
}