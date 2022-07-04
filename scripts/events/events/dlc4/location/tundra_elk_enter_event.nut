this.tundra_elk_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.tundra_elk_enter";
		this.m.Title = "En approchant...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_142.png[/img]{Dans la toundra stérile, vous trouvez un terrain de chasse de premier choix autour d\'un petit lac, et vous décidez donc de partir pour une petite chasse d\'un jour.\n\nVous repérez rapidement un élan de taille importante qui broute l\'herbe maigre de la toundra. Au moment où vous vous apprêtez à tirer, le cou de l\'élan se bloque et son museau pointe droit devant. Les os craquent et ses membres se tordent comme s\'ils étaient saisis par une mort instantanée, mais il ne tombe pas. Le garrot tremble, puis se bombe et se déplace comme si des poings roulaient sous sa fourrure. Soudain, la chair se déchire et on peut voir une masse bleue gluante bouillonner entre les blessures. Ses pattes s\'écartent et le torse s\'élève dans les airs, tandis que de longues tiges d\'os épais s\'agrippent au sol et que des bandes de muscles vermoulus, semblables à des serpents, s\'enroulent autour des tiges. Vous croyiez l\'élan mort, mais sa gueule gémit sauvagement juste au moment où son visage se déchire de ses bois à la mâchoire comme une fleur qui s\'épanouit. Le visage de quelque chose d\'entièrement différent émerge, il pousse en avant comme s\'il était généré par le sang qu\'il était occupé à récolter. Lorsque le nouveau monstre retrouve sa puissance, il se dresse sur ses deux pattes arrière et tend ses mains en arrière pour arracher la fourrure de l\'élan comme un homme le ferait d\'un manteau. Le sang et les os giclent.\n\n Une bête hideuse, trois fois plus grande que n\'importe quel homme, se retourne et tâte ses membres, tendant ses mains, faisant craquer ses genoux et ses épaules, tournant sa tête d\'un côté à l\'autre avec ses grosses narines qui s\'agitent comme celles d\'un taureau. Les orbites sont entièrement en os et une brume bleue y palpite comme des orages crépitants. Les magnifiques bois de l\'élan ont été abrogés par d\'horribles cornes. Un air glacé s\'échappe de sa bouche et on peut voir les feuilles d\'un arbre voisin devenir froides et cassantes. \n\n Vous avez le sentiment désagréable que ce monstre n\'est pas du tout un monstre, mais un esprit éphémère qui se manifeste comme il l\'entend, se gravant dans le monde comme un aspect du chaos. Au moment même où vous pensez cela, la bête tourne la tête vers vous et plante ses longs ongles dans les coins de sa gueule et étire les lèvres si loin que les coins pourraient être ses oreilles.%SPEECH_ON%Ahhh, c\'est l\'endroit où il faut être, c\'est l\'endroit où je suis heureux. Pourquoi me regardez-vous avec tant de crainte, ne suis-je pas qu\'un simple cerf?%SPEECH_OFF%Sa tête se penche sur le côté, de la bave coule sur sa lèvre inférieure et des larmes de joie remplissent ses yeux. Vous avez entendu des histoires sur cette créature, une horreur cruelle que les gens du nord appellent Ijirok ou la Bête de l\'hiver. Vous savez qu\'il n\'est pas là pour faire de la poésie ou jouer à des jeux. Vous tirez votre épée, mais une main vous tape sur l\'épaule.%SPEECH_ON%Toujours avec vous, capitaine.%SPEECH_OFF%Vous vous retournez pour voir la compagnie à vos côtés, prête à se battre.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous allons détruire cette chose!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setAttackable(true);
							this.World.State.getLastLocation().setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
						}

						this.World.Events.showCombatDialog(true, true, true);
						return 0;
					}

				},
				{
					Text = "Nous devons sortir d'ici! Vite!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

