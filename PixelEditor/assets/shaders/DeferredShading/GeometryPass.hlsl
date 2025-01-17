//------mesh constants------
cbuffer cbPerObject : register(b0)
{
	float4x4 gWorld;//world matrix
};
//------mesh constants------

cbuffer cbPass : register(b1)
{
	float4x4 gViewProjection;
};

struct VertexIn
{
	float3 PosL : POSITION;
	float2 TexCoord : TEXCOORD;
	float3 NormalL : NORMAL;
	int Editor : EDITOR;
};

struct VertexOut
{
	float4 PosH : SV_POSITION;
	float3 PosW : POSITION;
	float2 TexCoord : TEXCOORD;
	float3 NormalW : NORMAL;
	int Editor : EDITOR;
};

struct PixelOut
{
	float4 gBufferPosition : SV_Target;
	float4 gBufferNormal : SV_Target1;
	float4 gBufferAlbedo : SV_Target2;
	float4 gBufferRoughnessMetallicEmissive : SV_Target3;
};

VertexOut VS(VertexIn vin)
{
	VertexOut vout = (VertexOut)0.0f;

	//to world space
	float4 posW = mul(float4(vin.PosL, 1.0f), gWorld);
	vout.PosW = posW.xyz;

	vout.NormalW = mul(vin.NormalL, (float3x3)gWorld);

	//homogeneous clipping
	//vout.PosH = mul(posW, gView);
	vout.PosH = mul(posW, gViewProjection);

	vout.TexCoord = vin.TexCoord;

	vout.Editor = vin.Editor;
	return vout;
}

//------material texture------
Texture2D gAlbedoMap : register(t0);
Texture2D gNormalMap : register(t1);
Texture2D gRoughnessMap : register(t2);
Texture2D gMetallicMap : register(t3);
Texture2D gEmissiveMap : register(t4);
//------material texture------

//------material samplers------
SamplerState gsamPointWrap : register(s0);//static sampler
//------material samplers------

float3 DecodeNormalMap(float2 uv, float3 worldPos, float3 normal)
{
	float3 TangentNormal = gNormalMap.Sample(gsamPointWrap, uv).xyz * 2.0f - 1.0f;

	float3 Q1 = ddx(worldPos);
	float3 Q2 = ddy(worldPos);
	float2 st1 = ddx(uv);
	float2 st2 = ddx(uv);

	float3 N = normalize(normal);
	float3 T = normalize(Q1 * st2.y - Q2 * st1.y);
	float3 B = -normalize(cross(N, T));
	float3x3 TBN = float3x3(T, B, N);

	//let the texture map's normal to world's normal
	return normalize(mul(TangentNormal, TBN));
}

PixelOut PS(VertexOut pin)
{
	//write out to gbuffer
	PixelOut pixelOut = (PixelOut)(0.0f);
	pixelOut.gBufferPosition.xyz = pin.PosW;
	pixelOut.gBufferNormal.xyz = DecodeNormalMap(pin.TexCoord, pin.PosW, pin.NormalW);
	pixelOut.gBufferAlbedo.xyz = gAlbedoMap.Sample(gsamPointWrap, pin.TexCoord).xyz * 2.0f - 1.0f;
	pixelOut.gBufferRoughnessMetallicEmissive.x = gRoughnessMap.Sample(gsamPointWrap, pin.TexCoord).x;
	pixelOut.gBufferRoughnessMetallicEmissive.y = gMetallicMap.Sample(gsamPointWrap, pin.TexCoord).y;
	pixelOut.gBufferRoughnessMetallicEmissive.z = gEmissiveMap.Sample(gsamPointWrap, pin.TexCoord).z;

	return pixelOut;
}	