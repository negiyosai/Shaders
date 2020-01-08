Shader "DivinosDev/Spotlight"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_PlaneCentrePos("Plane Centre Position", vector) = (0,0,0,0)
		_CircleRadius("Spotlight Size", Range(0,20)) = 3
		_RingRadius("Ring Size", Range(0,5)) = 1
		_ColorTint("Base Color", Color) = (0,0,0,0)


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
				
				float3 worldPos : TEXCOORD1; // World position of the vertext 
											 //TEXCOORD2 for further variables
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

			float4 _PlaneCentrePos;
			float _CircleRadius;
			float _RingRadius;
			float4 _ColorTint;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex); 
	
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;


                return o;
            }

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = _ColorTint;

			    float dist = distance(i.worldPos, _PlaneCentrePos.xyz); // get distance between character and pixel
			
				//This is the spotlight section

				if (dist < _CircleRadius)   // if the distance between centre and characterposition is less than the spotlight circle, make that part visible
					col = tex2D(_MainTex, i.uv);   //this line is same as starting line of the frag function which assigns the given texture to the material


				//This is the blending section between spotlight end and base start
				else if (dist > _CircleRadius && dist < _CircleRadius + _RingRadius)
				{
					float blendStrength = dist - _CircleRadius;
					col = lerp(tex2D(_MainTex, i.uv), _ColorTint, blendStrength / _RingRadius);
				}
					//This is the base colour (Remaining area) section

			     
			    

                return col;
            }
            ENDCG
        }
    }
}
