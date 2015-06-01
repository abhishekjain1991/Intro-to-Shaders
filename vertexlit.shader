v2f vert_specmapvertexlit(a2v input) { v2f output;
output.sv = mul (UNITY_MATRIX_MVP, input.v);
float3 vWorldPos = mul (_Object2World, input.v).xyz;
// To transform normals, we want to use the inverse transpose of upper left 3x3
// Putting input.n in first argument is like doing trans((float3x3)_World2Object) * input.n; float3 nWorld = normalize(mul(input.n, (float3x3) _World2Object));
// Unity light position convention is:
// w = 0, directional light, with x y z pointing in opposite of light direction
// w = 1, point light, with x y z indicating position coordinates
float3 lightDir = normalize(_WorldSpaceLightPos0.xyz - vWorldPos * _WorldSpaceLightPos0.w); float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - vWorldPos);
float3 h = normalize(lightDir + eyeDir);
//output.diff_almost = 2*unity_LightColor0.rgb * max(0, dot(nWorld, lightDir)); float w = (1+(dot(nWorld,lightDir)))/2;
output.diff_almost=lerp(float3(0,0,1),float3(1,1,0),w);
float ndoth = max(0, dot(nWorld, h));
output.spec_almost = 2*unity_LightColor0.rgb * _SpecColor.rgb * pow(ndoth, _Shininess*128.0);
output.tc = TRANSFORM_TEX(input.tc, _BaseTex);
return output; }
float4 frag_specmapvertexlit(v2f input) : COLOR {
float4 base = tex2D(_BaseTex, input.tc);
float3 output = (input.diff_almost + 2*0*UNITY_LIGHTMODEL_AMBIENT.rgb) * base.rgb
+ 0*input.spec_almost.rgb * base.a; return(float4(output,1));
}
ENDCG
￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼￼