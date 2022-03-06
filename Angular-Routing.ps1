$readDir = "C:\Users\Lily\source\repos\Echocondria\src\app\pages"
$writeFile = "C:\Users\Lily\source\repos\Echocondria\src\app\app-routing.module.ts"
$list = Get-ChildItem -Path $readDir -Directory -Recurse -Force
$TextInfo = (Get-Culture).TextInfo

$routes = "const routes: Routes = [
  "

$imports = "import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';"

$end = "];
@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }"

ForEach($n in $list){
  $componentName = $TextInfo.ToTitleCase($n.Name) + "Component"
  $componentName = $componentName.Replace("-","")
  $parent = $n.Parent
  if($parent.Name -eq "pages"){
    $parent = ""
  } else {
    $parent = $parent.Name + "/"
  }
  $imports += "import { " + $componentName + " } from './pages/" + $parent + $n.Name + "/"+ $n.Name + ".component';
    "
  $routes += "{ path: '"+$n.Name+"', component: "+$componentName + " },
    "
}

Copy-Item $writeFile -Destination $writeFile+".backup"

$final = $imports + $routes + $end
$final | Out-File $writeFile

Invoke-Expression $writeFile