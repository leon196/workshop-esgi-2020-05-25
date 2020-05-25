Shader "Leon/BakeVertex"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct attribute
            {
                float4 position : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct varying
            {
                float4 texcoord : TEXCOORD0;
                float4 position : SV_POSITION;
            };

            sampler2D _MainTex;

            varying vert (attribute v)
            {
                varying o;
                o.position = float4(v.texcoord.x * 2. - 1., 0, 0, 1);
                o.texcoord = mul(unity_ObjectToWorld, v.position);
                return o;
            }

            fixed4 frag (varying i) : SV_Target
            {
                return i.texcoord;
            }
            ENDCG
        }
    }
}
