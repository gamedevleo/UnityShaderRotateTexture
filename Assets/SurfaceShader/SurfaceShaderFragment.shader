Shader "Custom/SurfaceShaderFragment"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Bright("Bright", Range(0,1)) = 0.5
		_ScrollX("ScrollX",float) = 1
		_ScrollY("ScrollY",float)  = 1

    }
    SubShader
    {
		Blend SrcAlpha OneMinusSrcAlpha
        Tags { "RenderType"="Opaque" "Queue" ="Transparent"}
        LOD 200
		
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert alpha

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0
#include "UnityCG.cginc"
        sampler2D _MainTex;
	fixed4 _Color;
	float _Bright;
	float _ScrollX;
	float _ScrollY;

        struct Input
        {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o)
        {
			float2 tempUV = IN.uv_MainTex;
			tempUV.x += _Time.x*_ScrollX;
			tempUV.y += _Time.y*_ScrollY;

			fixed4 c = tex2D(_MainTex, tempUV)*_Color + fixed4(_Bright,_Bright,_Bright,0);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
