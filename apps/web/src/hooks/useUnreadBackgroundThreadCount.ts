import { scopedThreadKey, scopeThreadRef } from "@t3tools/client-runtime/environment";
import type { EnvironmentThreadShell } from "@t3tools/client-runtime/state/models";
import { useParams } from "@tanstack/react-router";
import { useMemo } from "react";

import { hasUnseenCompletion } from "~/components/Sidebar.logic";
import { useThreadShells } from "~/state/entities";
import { resolveThreadRouteTarget } from "~/threadRoutes";
import { useUiStateStore } from "~/uiStateStore";
import { useWorkspaceTabsStore } from "~/workspaceTabsStore";

export function isThreadUnreadBackground(
  thread: EnvironmentThreadShell,
  lastVisitedAt: string | undefined,
  currentRouteThreadKey: string | null,
  openTabThreadKeys?: ReadonlySet<string> | undefined,
): boolean {
  if (thread.archivedAt !== null) return false;
  const threadKey = scopedThreadKey(scopeThreadRef(thread.environmentId, thread.id));
  if (threadKey === currentRouteThreadKey) return false;
  if (openTabThreadKeys?.has(threadKey)) return false;

  return hasUnseenCompletion({ ...thread, lastVisitedAt });
}

export function countUnreadBackgroundThreads(
  threads: ReadonlyArray<EnvironmentThreadShell>,
  threadLastVisitedAtById: Readonly<Record<string, string>>,
  currentRouteThreadKey: string | null,
  openTabThreadKeys?: ReadonlySet<string> | undefined,
): number {
  let count = 0;
  for (const thread of threads) {
    const threadKey = scopedThreadKey(scopeThreadRef(thread.environmentId, thread.id));
    const lastVisitedAt = threadLastVisitedAtById[threadKey];
    if (isThreadUnreadBackground(thread, lastVisitedAt, currentRouteThreadKey, openTabThreadKeys)) {
      count++;
    }
  }
  return count;
}

export function useUnreadBackgroundThreadCount(): number {
  const threads = useThreadShells();
  const threadLastVisitedAtById = useUiStateStore((state) => state.threadLastVisitedAtById);
  const openTabs = useWorkspaceTabsStore((state) => state.tabs);
  const routeTarget = useParams({
    strict: false,
    select: (params) => resolveThreadRouteTarget(params),
  });

  const openTabThreadKeys = useMemo(() => {
    const set = new Set<string>();
    for (const tab of openTabs) {
      if (tab.kind === "server") {
        set.add(scopedThreadKey(scopeThreadRef(tab.environmentId, tab.threadId)));
      }
    }
    return set;
  }, [openTabs]);

  const currentRouteThreadKey = useMemo(() => {
    if (routeTarget?.kind === "server") {
      return scopedThreadKey(routeTarget.threadRef);
    }
    return null;
  }, [routeTarget]);

  return useMemo(
    () =>
      countUnreadBackgroundThreads(
        threads,
        threadLastVisitedAtById,
        currentRouteThreadKey,
        openTabThreadKeys,
      ),
    [threads, threadLastVisitedAtById, currentRouteThreadKey, openTabThreadKeys],
  );
}
