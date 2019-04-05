Shader "Custom/Bluetint"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Foggyness ("Foggyness", Range(0, 1)) = 0
		_Blueness("Blueness", Range(0, 1)) = 0
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

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
			float _Foggyness;
			float _Blueness;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
				float lum = 1;
				float3 bw = float3(lum, lum, lum);

				float4 result = col;
				result.rgb = lerp(bw, col.rgb, _Foggyness);
				result.b += _Blueness;
                return result;
            }
            ENDCG
        }
    }
}
