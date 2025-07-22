module Engine.gameapplication;
import bindbc.sdl;
import Engine.scene;
import std.algorithm;
import std.stdio;

abstract class Application
{
    void delegate() switchAppCallback;
    void delegate() quitCallback;

    void Tick();
    void Start();
    void Stop();
}

class GameApplication : Application
{
	SDL_Renderer* mRendererRef;

	Scene[] mScenes;
	int mCurrScene = 0;

	this(SDL_Renderer* r)
	{
		mRendererRef = r;
	}

	void Input()
	{
		SDL_Event event;
		while (SDL_PollEvent(&event))
		{
			// Either quit or let the scene handle it
			if (event.type == SDL_QUIT)
				quitCallback();
			else if (event.type == SDL_KEYDOWN && event.key.keysym.sym == SDLK_ESCAPE)
				switchAppCallback();
			else
				mScenes[mCurrScene].Input(event);
		}
	}

	void Render()
	{
		SDL_SetRenderDrawColor(mRendererRef, 0, 0, 0, SDL_ALPHA_OPAQUE);
		SDL_RenderClear(mRendererRef);

		mScenes[mCurrScene].Render();

		SDL_RenderPresent(mRendererRef);
	}

	void Update()
	{
		mScenes[mCurrScene].Update();
	}

	void AdvanceFrame()
	{
		Input();
		Render();
		Update();
	}

	override void Tick()
	{
		int start = SDL_GetTicks();
		AdvanceFrame();

		int delay = start + 16 - int(SDL_GetTicks());
		SDL_Delay(max(delay, 0)); // Make sure no overflows
	}

	override void Start()
	{
	}

	override void Stop()
	{
	}
}
