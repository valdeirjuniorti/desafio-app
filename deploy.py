import sys
import subprocess
import argparse
import time
from pathlib import Path
from typing import List, Tuple


def log(message: str):
    timestamp = time.strftime('%Y-%m-%d %H:%M:%S')
    print(f"[{timestamp}] {message}")


def log_success(message: str):
    log(f"✓ {message}")


def log_error(message: str):
    log(f"✗ {message}")


def log_warning(message: str):
    log(f"⚠ {message}")


def run_command(cmd: List[str], check: bool = True, capture_output: bool = False) -> Tuple[int, str, str]:
    try:
        result = subprocess.run(
            cmd,
            check=check,
            capture_output=capture_output,
            text=True
        )
        stdout = result.stdout if capture_output else ""
        stderr = result.stderr if capture_output else ""
        return result.returncode, stdout, stderr
    except subprocess.CalledProcessError as e:
        if capture_output:
            return e.returncode, e.stdout, e.stderr
        return e.returncode, "", ""
    except FileNotFoundError:
        return 1, "", "Command not found"


def check_prerequisites() -> bool:
    log("Verificando pré-requisitos...")
    
    returncode, stdout, _ = run_command(["kubectl", "version", "--client"], check=False, capture_output=True)
    if returncode != 0:
        log_error("kubectl não está instalado. Por favor, instale o kubectl.")
        return False
    log_success(f"kubectl encontrado: {stdout.strip().split(chr(10))[0]}")
    
    returncode, _, _ = run_command(["kubectl", "cluster-info"], check=False, capture_output=True)
    if returncode != 0:
        log_error("Não é possível conectar ao cluster. Verifique sua configuração do kubectl.")
        return False
    
    returncode, stdout, _ = run_command(["kubectl", "config", "current-context"], check=False, capture_output=True)
    if returncode == 0:
        log_success(f"Conectado ao cluster: {stdout.strip()}")
    
    manifests_dir = Path(__file__).parent / "manifests"
    if not manifests_dir.exists():
        log_error(f"Diretório de manifests não encontrado: {manifests_dir}")
        return False
    log_success("Diretório de manifests encontrado")
    
    return True


def apply_manifest(file_path: Path, description: str, dry_run: bool = False) -> bool:
    if not file_path.exists():
        log_warning(f"Arquivo não encontrado: {file_path}")
        return False
    
    log(f"Aplicando {description}...")
    
    cmd = ["kubectl", "apply", "-f", str(file_path)]
    if dry_run:
        cmd.append("--dry-run=client")
        log_success(f"{description} (dry-run)")
        return run_command(cmd, check=False)[0] == 0
    else:
        returncode, _, _ = run_command(cmd, check=False)
        if returncode == 0:
            log_success(f"{description} aplicado com sucesso")
            return True
        else:
            log_error(f"Falha ao aplicar {description}")
            return False


def apply_namespace_resources(namespace: str, manifests_dir: Path, dry_run: bool = False) -> bool:
    namespace_dir = manifests_dir / namespace
    
    if not namespace_dir.exists():
        log_warning(f"Diretório do namespace não encontrado: {namespace_dir}")
        return True
    
    log(f"=== Aplicando recursos do namespace: {namespace} ===")
    
    resources = [
        ("namespace.yaml", "Namespace"),
        ("serviceaccount.yaml", "ServiceAccount"),
        ("configmap.yaml", "ConfigMap"),
        ("deployment.yaml", "Deployment"),
        ("service.yaml", "Service"),
        ("networkpolicy.yaml", "NetworkPolicy"),
        ("hpa.yaml", "HorizontalPodAutoscaler"),
        ("ingress.yaml", "Ingress"),
    ]
    
    success = True
    for file_name, resource_type in resources:
        file_path = namespace_dir / file_name
        if file_path.exists():
            if not apply_manifest(file_path, f"{resource_type} {namespace}", dry_run):
                success = False
    
    if success:
        log_success(f"Recursos do namespace {namespace} aplicados")
    
    return success


def apply_observability(manifests_dir: Path, dry_run: bool = False, skip: bool = False) -> bool:
    if skip:
        log_warning("Pulando deploy de observabilidade (--skip-observability)")
        return True
    
    obs_dir = manifests_dir / "observability"
    
    if not obs_dir.exists():
        log_warning(f"Diretório de observabilidade não encontrado: {obs_dir}")
        return True
    
    log("=== Aplicando recursos de observabilidade ===")
    
    resources = [
        ("namespace.yaml", "Namespace observability"),
        ("prometheus-serviceaccount.yaml", "ServiceAccount prometheus"),
        ("prometheus-configmap.yaml", "ConfigMap prometheus"),
        ("prometheus-deployment.yaml", "Deployment prometheus"),
        ("prometheus-service.yaml", "Service prometheus"),
        ("loki-configmap.yaml", "ConfigMap loki"),
        ("loki-deployment.yaml", "Deployment loki"),
        ("loki-service.yaml", "Service loki"),
        ("promtail-serviceaccount.yaml", "ServiceAccount promtail"),
        ("promtail-configmap.yaml", "ConfigMap promtail"),
        ("promtail-daemonset.yaml", "DaemonSet promtail"),
    ]
    
    success = True
    for file_name, description in resources:
        file_path = obs_dir / file_name
        if file_path.exists():
            if not apply_manifest(file_path, description, dry_run):
                success = False
    
    if success:
        log_success("Recursos de observabilidade aplicados")
    
    return success


def check_secrets(dry_run: bool = False) -> bool:
    log("Verificando secrets necessários...")
    
    secrets_ok = True
    
    returncode, _, _ = run_command(
        ["kubectl", "get", "secret", "backend-secrets", "-n", "backend"],
        check=False,
        capture_output=True
    )
    if returncode != 0:
        log_warning("Secret 'backend-secrets' não encontrado no namespace 'backend'")
        log_warning("Crie o secret manualmente com:")
        print("  kubectl create secret generic backend-secrets \\")
        print("    --from-literal=DATABASE_URL='postgres://user:pass@host:5432/db' \\")
        print("    -n backend")
        secrets_ok = False
    else:
        log_success("Secret 'backend-secrets' encontrado")
    
    returncode, _, _ = run_command(
        ["kubectl", "get", "secret", "registry-secret", "-n", "backend"],
        check=False,
        capture_output=True
    )
    if returncode != 0:
        log_warning("Secret 'registry-secret' não encontrado no namespace 'backend'")
        log_warning("Crie o secret manualmente com:")
        print("  kubectl create secret docker-registry registry-secret \\")
        print("    --docker-server=us-central1-docker.pkg.dev \\")
        print("    --docker-username=_json_key \\")
        print("    --docker-password=$(cat key.json) \\")
        print("    -n backend")
        secrets_ok = False
    else:
        log_success("Secret 'registry-secret' encontrado no namespace 'backend'")
    
    returncode, _, _ = run_command(
        ["kubectl", "get", "secret", "registry-secret", "-n", "frontend"],
        check=False,
        capture_output=True
    )
    if returncode != 0:
        log_warning("Secret 'registry-secret' não encontrado no namespace 'frontend'")
        log_warning("Crie o secret manualmente com:")
        print("  kubectl create secret docker-registry registry-secret \\")
        print("    --docker-server=us-central1-docker.pkg.dev \\")
        print("    --docker-username=_json_key \\")
        print("    --docker-password=$(cat key.json) \\")
        print("    -n frontend")
        secrets_ok = False
    else:
        log_success("Secret 'registry-secret' encontrado no namespace 'frontend'")
    
    if not secrets_ok and not dry_run:
        log_warning("Alguns secrets estão faltando.")
        response = input("Deseja continuar mesmo assim? (s/N): ").strip().lower()
        if response not in ['s', 'sim', 'y', 'yes']:
            return False
    
    return True


def wait_for_pods(namespaces: List[str], dry_run: bool = False, timeout: int = 300) -> None:
    if dry_run:
        return
    
    log("Aguardando pods ficarem prontos...")
    
    for ns in namespaces:
        returncode, _, _ = run_command(
            ["kubectl", "get", "namespace", ns],
            check=False,
            capture_output=True
        )
        if returncode != 0:
            continue
        
        log(f"Aguardando pods no namespace {ns}...")
        returncode, _, _ = run_command(
            ["kubectl", "wait", "--for=condition=ready", "pod", "--all", "-n", ns, f"--timeout={timeout}s"],
            check=False,
            capture_output=True
        )
        if returncode == 0:
            log_success(f"Todos os pods no namespace {ns} estão prontos")
        else:
            log_warning(f"Alguns pods no namespace {ns} podem não estar prontos")


def show_status(namespaces: List[str], dry_run: bool = False) -> None:
    if dry_run:
        return
    
    log("=== Status do Deploy ===")
    
    for ns in namespaces:
        returncode, _, _ = run_command(
            ["kubectl", "get", "namespace", ns],
            check=False,
            capture_output=True
        )
        if returncode == 0:
            print()
            log(f"Namespace: {ns}")
            run_command(["kubectl", "get", "all", "-n", ns], check=False)


def main():
    parser = argparse.ArgumentParser(
        description="Script único de deploy para o cluster Kubernetes",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Exemplos:
  python deploy.py
  python deploy.py --namespace backend
  python deploy.py --dry-run
  python deploy.py --skip-observability
        """
    )
    
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Executa em modo dry-run (não aplica mudanças)"
    )
    parser.add_argument(
        "--skip-observability",
        action="store_true",
        help="Pula o deploy dos recursos de observabilidade"
    )
    parser.add_argument(
        "--namespace",
        choices=["backend", "frontend", "observability"],
        help="Aplica apenas recursos de um namespace específico"
    )
    
    args = parser.parse_args()
    
    print()
    log("==========================================")
    log("  Script de Deploy - Desafio App")
    log("==========================================")
    print()
    
    if args.dry_run:
        log_warning("Modo DRY-RUN ativado - nenhuma mudança será aplicada")
    
    if not check_prerequisites():
        sys.exit(1)
    
    if not check_secrets(args.dry_run):
        sys.exit(1)
    
    print()
    
    manifests_dir = Path(__file__).parent / "manifests"
    success = True
    
    if args.namespace:
        if args.namespace == "observability":
            success = apply_observability(manifests_dir, args.dry_run, args.skip_observability)
        else:
            success = apply_namespace_resources(args.namespace, manifests_dir, args.dry_run)
    else:
        success = apply_namespace_resources("backend", manifests_dir, args.dry_run)
        success = apply_namespace_resources("frontend", manifests_dir, args.dry_run) and success
        success = apply_observability(manifests_dir, args.dry_run, args.skip_observability) and success
    
    if not success:
        log_error("Alguns recursos falharam ao ser aplicados")
        sys.exit(1)
    
    print()
    
    namespaces = []
    if args.namespace:
        if args.namespace != "observability":
            namespaces.append(args.namespace)
        elif not args.skip_observability:
            namespaces.append("observability")
    else:
        namespaces = ["backend", "frontend"]
        if not args.skip_observability:
            namespaces.append("observability")
    
    wait_for_pods(namespaces, args.dry_run)
    print()
    show_status(namespaces, args.dry_run)
    print()
    
    log_success("Deploy concluído com sucesso!")
    
    if not args.dry_run:
        log("Para verificar os logs:")
        print("  kubectl logs -f deployment/backend -n backend")
        print("  kubectl logs -f deployment/frontend -n frontend")
        print()
        log("Para verificar o status:")
        print("  kubectl get all --all-namespaces")


if __name__ == "__main__":
    main()

