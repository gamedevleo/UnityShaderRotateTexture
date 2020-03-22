Shader "Hidden/AlphaTes"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Alpha("Alpha",Range(0.0,1.0)) = 0.5
    }
    SubShader
    {
        // No culling or depth
        //Cull Off ZWrite Off 
		//ZTest Always
		Blend SrcAlpha OneMinusSrcAlpha
		Tags { "RenderType" = "Opaque" "Queue" = "Transparent"}
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag Lambert alpha

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
			float _Alpha;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                // just invert the colors
        
			if (col.a < _Alpha)
			{
				
				return col.a = 0;
			}
			else
			{
				
				return col;
			}

			//return col;
            }
            ENDCG
        }
    }
}
