#pragma once

#include "Core.h"

#include "Window.h"
#include "Pixel/LayerStack.h"
#include "Pixel/Events/Event.h"
#include "Pixel/Events/ApplicationEvent.h"

namespace Pixel {
	class PIXEL_API Application
	{
	public:
		Application();
		virtual ~Application();

		void Run();
		bool OnWindowClose(WindowCloseEvent& e);
		void OnEvent(Event& e);

		//������ͨ�Ĳ�
		void PushLayer(Layer* layer);
		//����Overlay�����UI�������Ⱦ��������������
		void PushOverlay(Layer* layer);
	private:
		std::unique_ptr<Window> m_Window;
		bool m_Running = true;

		LayerStack m_LayerStack;
	};

	//To be defined in CLIENT
	Application* CreateApplication();
}


