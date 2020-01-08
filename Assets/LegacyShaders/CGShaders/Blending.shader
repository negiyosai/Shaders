Shader "DivinosDev/Blending"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
	    _SecondaryTex("Secondary Texture", 2D) = "white" {}
       //_LerpValue("Transition Float", Range(0,1)) = 0.5
	}
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			sampler2D _SecondaryTex;
			float4 _Secondary_ST;
			//float _LerpValue;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

			fixed4 frag(v2f i) : SV_Target
			{
				//fixed4 col = lerp(tex2D(_MainTex, i.uv),tex2D(_SecondaryTex, i.uv), _LerpValue);  //The LerpValue can be called from a C# script and changed there
				fixed4 col = lerp(tex2D(_MainTex, i.uv),tex2D(_SecondaryTex, i.uv), _SinTime.w);
                return col;
            }
            ENDCG
        }
    }
}
