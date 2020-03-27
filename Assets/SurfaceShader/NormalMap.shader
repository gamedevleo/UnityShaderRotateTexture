Shader "Custom/NormalMap"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NormTex("NormalMap",2D) = "white" {}
		_Range("Range",Range(0,2)) =1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
		sampler2D _NormTex;

        struct Input
        {
            float2 uv_MainTex;
			float2 uv_NormTex;
        };

        fixed4 _Color;
		float _Range;

      

        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			
			o.Normal = UnpackNormal(tex2D(_NormTex, IN.uv_NormTex));
            o.Albedo = c.rgb*_Range;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
