Shader "Unlit/Simple"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

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
                float2 texcoord : TEXCOORD0;
                float4 position : SV_POSITION;
            };

            sampler2D _MainTex;

            varying vert (attribute v)
            {
                varying o;
                o.position = UnityObjectToClipPos(v.position);
                o.texcoord = v.texcoord;
                return o;
            }

            fixed4 frag (varying i) : SV_Target
            {
                fixed4 color = tex2D(_MainTex, i.texcoord);
                return color;
            }
            ENDCG
        }
    }
}
