$readDir = "C:\Users\Lily\source\repos\Echocondria\src\app\pages"
$writeFile = "C:\Users\Lily\source\repos\Echocondria\src\app\app-routing.module.ts"
#$readDir = "C:\repos\AngularSite\src\app\pages"
#$writeFile = "C:\repos\AngularSite\src\app\app-routing.module.ts"
$list = Get-ChildItem -Path $readDir -Directory -Recurse -Force
$TextInfo = (Get-Culture).TextInfo


$imports = "import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
"

$routes = "const routes: Routes = [
"

$end = "];
@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }"

ForEach($n in $list){
  $componentName = $TextInfo.ToTitleCase($n.Name) + "Component"
  $componentName = $componentName.Replace("-","")
  $relative = $n.FullName.Substring($Root.Length)
  $relative = $relative.Replace($readDir,"")  
  $relative = $relative.Replace("\","/")
  $parent = $n.Parent
  if($parent.Name -eq "pages"){
    $parent = ""
  } else {
    $parent = $parent.Name + "/"
  }
  $imports += "import { " + $componentName + " } from './pages/" + $parent + $n.Name + "/"+ $n.Name + ".component';
"
  $routes += "{ path: '"+$relative+"', component: "+$componentName + " },
"
}

Copy-Item $writeFile -Destination $writeFile".backup"

$final = $imports + $routes + $end
#print $final
$final | Out-File $writeFile
write-output "routing file saved"
Pause
