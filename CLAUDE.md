# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run Commands

- **Build debug HAP**: `hvigorw assembleHap --mode module -p product=default -p buildMode=debug --no-daemon`
- **Build release HAP**: `hvigorw assembleHap --mode module -p product=default -p buildMode=release --no-daemon`
- **Run tests**: `hvigorw runohostests --mode module -p product=default -p buildMode=debug --no-daemon`
- **Lint**: `code-linter check` (uses `code-linter.json5` config)
- **Preview**: Open in DevEco Studio and use the Previewer tab

## Project Overview

HarmonyOS chat application built with ArkTS + ArkUI (SDK 6.0.2 / API 22). Uses Hvigor build system and the MVVM-like pattern.

## Navigation Architecture

Uses HarmonyOS `Navigation` component with `NavPathStack` for page routing (migrated from old `router` API). The main `Index` page wraps a `Tabs` component inside `Navigation`, with `hideTitleBar(true)` and `mode(NavigationMode.Stack)`. Pushing pages uses `this.pageStack.pushPathByName('ChatDetail', params)` and popping uses `this.pageStack.pop()`. Route params are read from `context.pathInfo.param` in the `onReady` lifecycle hook.

## MVVM Structure

```
entry/src/main/ets/
├── models/            # Data classes (ChatMessageModel, MessageModel, ChatRouteParams)
├── views/             # UI components (MessagePage, ChatBubble, ChatInputArea)
├── pages/             # Entry pages (Index, ChatDetail, Second)
├── viewmodels/        # Business logic layer, coordinates View ↔ Service
├── services/          # Data access / mock API layer (async fetch with simulated delay)
├── entryability/      # App lifecycle (EntryAbility)
└── entrybackupability/
```

- **Models** are plain classes using `@Observed` decorator for reactivity
- **ViewModels** are singletons (default export instance) that call Services and transform data
- **Services** simulate network calls with `setTimeout` + Promises (use real `@ohos.net.http` in production)
- **Views** use `@State`, `@Link`, `@Prop`, `@ObjectLink`, `@Consume` decorators for state management
- **State flows down** from pages through `@Link`/`@Prop` bindings; **events flow up** through callback props

## Key Patterns

- Chat detail uses `Scroller` with `scrollEdge(Edge.Bottom)` after new messages and history load (with 100ms setTimeout for render flush)
- Loading states tracked per-view: `isLoading` (initial) and `isRefreshing` (pull-to-refresh)
- `Refresh` component wraps `List` for pull-to-refresh on the message list page
- `Badge` component shows unread counts on chat list items
- `ChatInputArea` dynamically switches button from attachment ⊕ to 发送 when text is entered
