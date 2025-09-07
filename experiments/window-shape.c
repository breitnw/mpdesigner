#include <stdio.h>

#include <stdint.h>
#include <stdbool.h>

/* #include <SDL2/SDL.h> */
/* #include <SDL2/SDL_syswm.h> */
#include <SDL3/SDL.h>
#include <SDL3_image/SDL_image.h>

/* void setX11WindowTransparency(SDL_Window* window) { */
/*     SDL_SysWMinfo wmInfo; */
/*     SDL_VERSION(&wmInfo.version); */
/*     if (SDL_GetWindowWMInfo(window, &wmInfo)) { */
/*         if (wmInfo.subsystem == SDL_SYSWM_X11) { */
/*             Display* display = wmInfo.info.x11.display; */
/*             Window x11Window = wmInfo.info.x11.window; */

/*             // Create a pixmap for the shape mask */
/*             Pixmap shapePixmap = XCreatePixmap(display, x11Window, 800, 600, 1); */
/*             GC gc = XCreateGC(display, shapePixmap, 0, NULL); */

/*             // Fill with white (opaque) */
/*             XSetForeground(display, gc, 1); */
/*             XFillRectangle(display, shapePixmap, gc, 0, 0, 800, 600); */

/*             // Cut holes (black = transparent) */
/*             XSetForeground(display, gc, 0); */
/*             XFillRectangle(display, shapePixmap, gc, 100, 100, 200, 200); // Transparent area 1 */
/*             XFillRectangle(display, shapePixmap, gc, 400, 300, 150, 150); // Transparent area 2 */

/*             // Apply the shape mask */
/*             XShapeCombineMask(display, x11Window, ShapeBounding, 0, 0, shapePixmap, ShapeSet); */

/*             XFreeGC(display, gc); */
/*             XFreePixmap(display, shapePixmap); */
/*         } */
/*     } */
/* } */
int main() {
    SDL_Init(SDL_INIT_VIDEO);

    // Create window
    SDL_Window* window;
    SDL_Renderer* renderer;
    SDL_CreateWindowAndRenderer("transparent window",
                                400, 400,
                                SDL_WINDOW_TRANSPARENT | SDL_WINDOW_BORDERLESS, &window, &renderer);

    // Set X11 window transparency
    SDL_Surface* surf = IMG_Load("circle.png");

    /* SDL_RenderTexture(renderer, tex, &{, const SDL_FRect *dstrect) */
    if (SDL_SetWindowShape(window, surf) == false) {
        SDL_LogError(1, "error: %s", SDL_GetError());
    }
    SDL_Texture* tex = SDL_CreateTextureFromSurface(renderer, surf);
    SDL_DestroySurface(surf);

    bool running = true;
    SDL_Event event;

    while (running) {
        while (SDL_PollEvent(&event)) {
            if (event.type == SDL_EVENT_QUIT) {
                running = false;
            }
            if (event.type == SDL_EVENT_KEY_DOWN) {
                if (event.key.key == SDLK_ESCAPE) {
                    running = false;
                }
            }
        }

        // Clear with semi-transparent background
        SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
        SDL_RenderClear(renderer);

        // Draw some content
        SDL_SetRenderDrawColor(renderer, 255, 0, 0, 255);
        SDL_FRect rect = {200, 150, 50, 100};
        SDL_RenderFillRect(renderer, &rect);

        SDL_SetRenderDrawColor(renderer, 0, 255, 0, 255);
        SDL_RenderLine(renderer, 0, 0, 400, 400);
        SDL_RenderLine(renderer, 400, 0, 0, 400);

        SDL_RenderPresent(renderer);
        SDL_Delay(16);
    }

    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}
