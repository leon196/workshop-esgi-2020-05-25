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
                fixed4 color = tex2D(_MainTex, uv);

                // god's ray
                // const float count = 20.0;
                // for (float index = 1; index < count; ++index) {
                //     color += 0.1 * smoothstep(0.8, 1.0, tex2D(_MainTex, uv + float2(0.005,0.005) * index)) / (index/count);
                // }

                return color;
            }
            ENDCG
        }
    }
}
