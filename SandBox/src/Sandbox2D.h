#pragma once

#include "Pixel.h"

class Sandbox2D : public Pixel::Layer
{
public:
	Sandbox2D();
	virtual ~Sandbox2D() = default;
	virtual void OnAttach() override;
	virtual void OnDetach() override;
	void OnImGuiRender() override;
	virtual void OnUpdate(Pixel::Timestep ts)override;
	void OnEvent(Pixel::Event& e)override;
private:
	Pixel::OrthographicCameraController m_CameraController;

	Pixel::Ref<Pixel::VertexArray> m_SquareVA;
	Pixel::Ref<Pixel::Shader> m_FlatColorShader;

	Pixel::Ref<Pixel::Texture> m_CheckerboardTexture;
	Pixel::Ref<Pixel::Texture> m_CupTexture;

	//Sprite Sheets
	Pixel::Ref<Pixel::Texture2D> m_SpriteSheets;
	Pixel::Ref<Pixel::SubTexture2D> m_TextureStairs;

	glm::vec4 m_SquareColor = {0.2f, 0.3f, 0.8f, 1.0f};
};
