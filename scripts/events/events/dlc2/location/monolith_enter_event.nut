this.monolith_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.monolith_enter";
		this.m.Title = "En approchant...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_101.png[/img]{De loin, le Monolithe Noir ressemblait à une tour noire penchée. Le ciel au-dessus de nous était vierge, comme si les nuages et les oiseaux contournaient une montagne invisible. Un sentiment de paralysie s\'est installé dans l\'arrière-pays, une terre qui ne meurt ni ne croît, un silence cruel a rendu la vie inerte, pire que l\'absence de vie. Des aventuriers y sont allés et n\'en sont jamais revenus. Les histoires de leur disparition s\'empilaient jusqu\'à ce que leur absence recouvre entièrement le monolithe, le revêtant d\'une telle peur et d\'une telle menace que personne n\'osait s\'en approcher.\n\n Mais maintenant, la compagnie %companyname% se tient devant l\'obélisque comme des fourmis devant l\'acier d\'une épée plantée. Vous voyez ici que la structure n\'a pas du tout été construite sur la terre: l\'obélisque repose dans le puits d\'une carrière abandonnée. Les routes et les chemins s\'enfoncent dans les profondeurs comme une grande et creuse cavité en terre. Des sceaux attachés à des cordes sont suspendues à chaque intervalle, d\'innombrables seaux de terre laissés par terre comme des lanternes sans feu lors d\'une nuit de fête. Des attaches maintiennent les charpentes des ponts, les planches des passerelles sont tombées depuis longtemps, d\'autres encore s\'enroulent autour du monolithe, comme si une multitude d\'hommes avaient tenté de le faire descendre ou même de corriger son inclinaison. Vous supposez qu\'au fond de cette fosse abandonnée se trouve la base du monolithe. L\'édifice semble descendre bien au-delà de tout ce que vous pouvez imaginer. Des pelles et des pioches jonchent ses murs d\'obsidienne avec de la terre encore agglutinée sur leurs métaux. %randombrother% acquiesce en regardant les outils.%SPEECH_ON%On dirait que celui qui creusait là a été interrompu.%SPEECH_OFF%La voix de l\'homme porte si loin qu\'elle prend la forme d\'un écho. En regardant en arrière, vous voyez que le silence lui-même vous a suivi, mais même ici, au bord de la fosse, il est aussi pensif et impressionné que vous. La décision d\'entrer dans la carrière repose sur vos épaules.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Vous entrez.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Demi-tour.",
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
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_101.png[/img]{À mi-chemin dans la carrière et au détour d\'un long virage, vous remarquez une série de couloirs creusés dans le mur inférieur. Vous levez le poing. La compagnie s\'arrête, se heurtant les uns aux autres alors que la formation se fige. %randombrother% demande ce qui ne va pas. Vous mettez un doigt sur vos lèvres. \n\n Avec des pas très légers, vous vous approchez de l\'une des cordes tendues entre ce niveau et le fond de la fosse. Un seau rempli de terre fait vaciller la corde comme s\'il était secoué juste par votre présence. La poulie utilisée pour le faire monter et descendre est rouillée depuis longtemps. Vous dégainez votre épée et coupez la corde. La corde se détend comme un fouet qu\'on agite et le sceau entame sa chute. Il s\'entrechoque sur les rochers avant de heurter le sol dans un bruit de métal et un nuage de poussière. Et juste comme ça, le silence est parti.\n\n Des hommes pâles sortent des couloirs en contrebas, un flot de mineurs et de pelleteurs chétifs, vêtus de dessous, de bottes et de chemises déchiquetés, ils titubent comme s\'ils retournaient à un travail laissé inachevé depuis longtemps. Vous essayez de compter leur nombre mais vous êtes tout de suite distrait lorsqu\'une foule de soldats en armure sortent derrière eux, portant des armes de poing, des boucliers, des lances et, plus dangereux encore, un sentiment de cohésion.\n\n Ça ne sert à rien de sortir de la carrière en courant. Il n\'y a rien à fuir sur ces terres. Quand vous vous retournez vers les hommes, ils sont déjà en train de sortir leurs armes. %randombrother% hoche la tête.%SPEECH_ON%Avec vous jusqu\'au bout, capitaine.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Jusqu\'au bout!",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setAttackable(true);
							this.World.State.getLastLocation().setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getID());
						}

						this.World.Events.showCombatDialog(true, true, true);
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

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});

