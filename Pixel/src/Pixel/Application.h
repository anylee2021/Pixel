#pragma once

#include "Core.h"

#include "Window.h"
#include "Pixel/LayerStack.h"
#include "Pixel/Events/Event.h"
#include "Pixel/Events/ApplicationEvent.h"

#include "Pixel/ImGui/ImGuiLayer.h"

#include "Pixel/Renderer/Shader.h"
#include "Pixel/Renderer/Buffer.h"

namespace Pixel {
	class PIXEL_API Application
	{
	public:
		Application();
		virtual ~Application();

		void Run();
		bool OnWindowClose(WindowCloseEvent& e);
		void OnEvent(Event& e);

		//放置普通的层
		void PushLayer(Layer* layer);
		//放置Overlay在最后，UI层最后渲染，绘制在最上面
		void PushOverlay(Layer* layer);

		inline static Application& Get(){return *s_Instance;}
		inline Window& GetWindow(){ return *m_Window; }
	private:
		std::unique_ptr<Window> m_Window;
		ImGuiLayer* m_ImGuiLayer;
		bool m_Running = true;

		LayerStack m_LayerStack;

		unsigned int m_VertexArray;
		std::unique_ptr<Shader> m_Shader;
		std::unique_ptr<VertexBuffer> m_VertexBuffer;
		std::unique_ptr<IndexBuffer> m_IndexBuffer;
	private:
		static Application* s_Instance;
	};

	//To be defined in CLIENT
	Application* CreateApplication();
}


