module app;

import std.stdio;
import bindbc.sdl;
import Engine.gameapplication;
import Engine.resourcemanager;
import core.memory;

class MainApplication {
    SDL_Window* mWindow = null;
    SDL_Renderer* mRenderer = null;
    GameApplication game = null;
    bool gameRunning = true;

    this() {
        // Set up window
        mWindow = SDL_CreateWindow("Game", SDL_WINDOWPOS_UNDEFINED,
            SDL_WINDOWPOS_UNDEFINED, 1280, 720, SDL_WINDOW_SHOWN);
        mRenderer = SDL_CreateRenderer(mWindow, -1, SDL_RENDERER_ACCELERATED);

        // Create game application
        // game = new GameApp(mRenderer); // REPLACE WITH ACTUAL GAME APP
        game.quitCallback = &Quit;
    }

    ~this() {
        SDL_DestroyRenderer(mRenderer);
        SDL_DestroyWindow(mWindow);
    }

    void Run() {
        while (gameRunning) {
            game.Tick();
        }
    }

    void Quit() {
        gameRunning = false;
    }
}

// Main entry point. Add code to make a GameApplication and run it here.
void main() {
    MainApplication app = new MainApplication();
    app.Run();
}
