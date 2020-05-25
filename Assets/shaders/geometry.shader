Shader "Unlit/Geometry"
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
            #pragma geometry geom
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct attribute
            {
                float4 position : POSITION;
                float2 texcoord : TEXCOORD0;
            };

            struct varyingGeometry
            {
                float2 texcoord : TEXCOORD0;
                float4 position : SV_POSITION;
            };

            struct varying
            {
                float2 texcoord : TEXCOORD0;
                float4 position : SV_POSITION;
            };

            sampler2D _MainTex;

            varyingGeometry vert (attribute v)
            {
                varyingGeometry o;
                o.position = v.position;
                o.texcoord = v.texcoord;
                return o;
            }

            [maxvertexcount(3)]
            void geom (triangle varyingGeometry input[3], inout TriangleStream<varying> stream)
            {
                varyingGeometry v = input[0];
                varying o;
                o.texcoord = v.texcoord;
                float size = 0.5;
                o.position = UnityObjectToClipPos(v.position + float4(size,0,0,0));
                stream.Append(o);
                o.position = UnityObjectToClipPos(v.position - float4(size,0,0,0));
                stream.Append(o);
                o.position = UnityObjectToClipPos(v.position + float4(0,size,0,0));
                stream.Append(o);

                stream.RestartStrip();
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
