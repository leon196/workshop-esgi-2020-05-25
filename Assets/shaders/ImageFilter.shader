Shader "Hidden/ImageFilter"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;

            fixed4 frag (v2f_img i) : SV_Target
            {
                float2 uv = i.uv;
                uv.y = 1.-uv.y;
                fixed4 color = tex2D(_MainTex, uv);

                return color;
            }
            ENDCG
        }
    }
}
