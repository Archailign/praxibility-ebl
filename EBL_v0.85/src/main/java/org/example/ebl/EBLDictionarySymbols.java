package org.example.ebl; import java.io.*; import java.nio.file.*; import java.util.*; import com.fasterxml.jackson.databind.*; import com.fasterxml.jackson.core.type.TypeReference;
public class EBLDictionarySymbols {
  public static class Dict { public Core core; public Map<String, Domain> domains; }
  public static class Core { public Keywords keywords; public Map<String,String> verbPermissions; public List<String> relationshipTypes; }
  public static class Keywords { public List<String> reserved; }
  public static class Domain { public List<String> entities, dataObjects, verbs, actors, relationships; public Map<String,List<String>> actorVerbs; public Map<String,Perms> actorDataPerms; public Map<String,List<String>> docTypesByJurisdiction; }
  public static class Perms { public List<String> read, write; }
  public final Set<String> reserved = new HashSet<>(); public final Map<String,String> verbPermissions = new HashMap<>();
  private final Set<String> actors = new HashSet<>(); private final Set<String> verbs  = new HashSet<>(); private final Set<String> relTypes = new HashSet<>();
  private final Map<String, Set<String>> actorVerbs = new HashMap<>(); private final Map<String, Set<String>> actorRead = new HashMap<>(); private final Map<String, Set<String>> actorWrite = new HashMap<>();
  private final Set<String> unionAllowedVerbs = new HashSet<>();
  public static EBLDictionarySymbols fromPath(String path) throws IOException {
    String content = Files.readString(Path.of(path)); ObjectMapper om = new ObjectMapper(); Dict d = om.readValue(content, new TypeReference<Dict>(){}); EBLDictionarySymbols s = new EBLDictionarySymbols();
    if (d.core != null) { if (d.core.keywords != null && d.core.keywords.reserved != null) d.core.keywords.reserved.forEach(k -> s.reserved.add(k.toUpperCase(Locale.ROOT))); if (d.core.verbPermissions != null) d.core.verbPermissions.forEach((k,v)-> s.verbPermissions.put(canon(k), v.toLowerCase(Locale.ROOT))); if (d.core.relationshipTypes != null) d.core.relationshipTypes.forEach(t-> s.relTypes.add(canon(t))); }
    if (d.domains != null) for (Map.Entry<String,Domain> e : d.domains.entrySet()) { Domain dom = e.getValue(); if (dom == null) continue; if (dom.actors != null) dom.actors.forEach(a-> s.actors.add(canon(a))); if (dom.verbs  != null) dom.verbs.forEach(v-> s.verbs.add(canon(v)));
      if (dom.actorVerbs != null) for (var av : dom.actorVerbs.entrySet()) { var a=canon(av.getKey()); var vs=new HashSet<String>(); for (var v: av.getValue()) vs.add(canon(v)); s.actorVerbs.computeIfAbsent(a, k-> new HashSet<>()).addAll(vs); s.unionAllowedVerbs.addAll(vs); }
      if (dom.actorDataPerms != null) for (var ap : dom.actorDataPerms.entrySet()) { var a = canon(ap.getKey()); var p = ap.getValue(); if (p.read  != null) s.actorRead .computeIfAbsent(a, k-> new HashSet<>()).addAll(canonAll(p.read)); if (p.write != null) s.actorWrite.computeIfAbsent(a, k-> new HashSet<>()).addAll(canonAll(p.write)); } if (dom.relationships != null) dom.relationships.forEach(r-> s.relTypes.add(canon(r))); }
    return s;
  }
  public boolean hasActor(String a){ return actors.contains(canon(a)); } public boolean hasVerb(String v){ return verbs.contains(canon(v)); }
  public boolean actorAllowsVerb(String a, String v){ var set = actorVerbs.get(canon(a)); return set==null || set.isEmpty() || set.contains(canon(v)); }
  public boolean canRead(String actor, String dobj){ var s = actorRead.get(canon(actor)); return s==null || s.contains(canon(dobj)); }
  public boolean canWrite(String actor, String dobj){ var s = actorWrite.get(canon(actor)); return s==null || s.contains(canon(dobj)); }
  public Optional<String> permForVerb(String v){ return Optional.ofNullable(verbPermissions.get(canon(v))); }
  public boolean isRelType(String t){ return relTypes.contains(canon(t)); }
  public boolean permittedByAnyActor(String v){ return unionAllowedVerbs.isEmpty() ? true : unionAllowedVerbs.contains(canon(v)); }
  private static String canon(String s){ return s==null? "" : s.replaceAll("[^A-Za-z0-9_]+","").toLowerCase(Locale.ROOT); } private static Set<String> canonAll(Collection<String> c){ var out=new HashSet<String>(); if(c!=null) c.forEach(x-> out.add(canon(x))); return out; }
}
