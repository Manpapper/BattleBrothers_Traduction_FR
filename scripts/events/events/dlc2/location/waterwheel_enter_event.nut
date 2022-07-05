this.waterwheel_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.waterwheel_enter";
		this.m.Title = "En approchant...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_109.png[/img]{La roue à eau vacille sur ses charnières tandis que ses godets plongent et puisent l\'eau. Attenante à son flanc, se trouve une demeure en pierre avec une cheminée au conduit noir. Des peaux et des pièges sont accrochés aux murs, une chaise en chêne est posée sur le porche. Ses fenêtres sont trop opaques pour qu\'on puisse y jeter un coup d\'œil, mais on peut entendre le moulin à l\'intérieur se lever et tourner dans des craquements de bois. Dégainant votre épée, vous montez sur le porche et ouvrez la porte.\n\n Un homme vous accueille dans la première et seule pièce qui existe. Il est debout à côté du moulin, passant sa main dans le grain. Il s\'agit d\'un homme âgé mais de stature modeste, comme si le temps n\'avait pas de prise sur lui. Il y a un manche d\'épée suspendue au-dessus de la cheminée. Son reflet est d\'une richesse inégalée, le vieil homme vous regarde avec un sourire chaleureux.%SPEECH_ON%Seuls ceux qui en sont dignes peuvent avoir la poignée de %weapon%. Vous, étranger, ne l\'êtes pas.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ce vieil homme ne va pas m\'arrêter.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Qu\'est-ce qui me rendrait digne?",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				if (this.World.State.getLastLocation() != null)
				{
					this.World.State.getLastLocation().setVisited(false);
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_109.png[/img]{Vous vous avancez et menacez l\'homme de s\'écarter ou d\'affronter votre acier. Il fait un signe de la main et vos pieds quittent le sol. Un coup de vent vous projette contre le mur avec une telle force que vous entendez l\'argenterie s\'entrechoquer et la poussière tomber du plafond. Le vieil homme vous regarde aussi calmement qu\'à la seconde où vous avez franchi sa porte.%SPEECH_ON%Seulement ceux qui en sont dignes. Vous comprenez?%SPEECH_OFF%Il n\'y a rien d\'autre à faire à part acquiescer. La main du vieil homme se baisse et vous tombez au sol. Vous ramassez votre épée, en vous assurant qu\'il comprend que vous ne faites que la rengainer. Vous demandez ce qui vous rendrait digne. Le vieil homme sourit à nouveau.%SPEECH_ON%Mon fils unique était digne. Il est parti combattre la grande bête. Vengez-le et vous en serez digne.%SPEECH_OFF%Vous êtes chassé de la maison, la porte claque derrière vous. Il semble que vous ayez une quête, bien que vous ne sachiez pas trouver le nord sur une boussole.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous allons devoir nous débrouiller seuls.",
					function getResult( _event )
					{
						this.World.Flags.set("IsWaterWheelVisited", true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_109.png[/img]{Le vieil homme fixe le moulin. Sa main se lève et un nuage de grains tourne autour de ses doigts comme les abeilles autour des bourgeons de canne à sucre.%SPEECH_ON%Mon fils unique est parti pour tuer la grande bête. Son écuyer m\'a rendu le manche, mais la lame avait disparu. Vengez mon fils, et vous en serez digne, étranger.%SPEECH_OFF%Vous demandez où est la bête et l\'homme remet sa main les grains.%SPEECH_ON%Si seulement je le savais. Je suis sûr que vous le découvrirez, mercenaire.%SPEECH_OFF%Vos pieds glissent soudainement sur le sol, puis sur le porche et enfin sur l\'herbe. La porte claque devant vous et reste fermée. Il semble que vous ayez involontairement entrepris une quête, ou peut-être une quête à garder sous le coude.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous allons devoir nous débrouiller seuls.",
					function getResult( _event )
					{
						this.World.Flags.set("IsWaterWheelVisited", true);
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "A2",
			Text = "[img]gfx/ui/events/event_109.png[/img]{L\'homme âgé vous attend déjà lorsque vous entrez. Il se retourne assez rapidement comme s\'il était interrompu.%SPEECH_ON%Vous êtes donc de retour! Et avez-vous réussi? Avez-vous vengé mon garçon? Etes-vous, mercenaire, digne?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Cela me rendrait-il digne?",
					function getResult( _event )
					{
						return "C2";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B2",
			Text = "[img]gfx/ui/events/event_109.png[/img]{La roue à eau vacille sur ses charnières tandis que ses godets plongent et puisent l\'eau. Attenante à son flanc, se trouve une demeure en pierre avec une cheminée au conduit noir. Des peaux et des pièges sont accrochés aux murs, une chaise en chêne est posée sur le porche. Ses fenêtres sont trop opaques pour qu\'on puisse y jeter un coup d\'œil, mais on peut entendre le moulin à l\'intérieur se lever et tourner dans des craquements de bois. Dégainant votre épée, vous montez sur le porche et ouvrez la porte.\n\n Un homme vous accueille dans la première et seule pièce qui existe. Il est debout à côté du moulin, passant sa main dans le grain. Il s\'agit d\'un homme âgé mais de stature modeste, comme si le temps n\'avait pas de prise sur lui. Il y a un manche d\'épée suspendue au-dessus de la cheminée. Son reflet est d\'une richesse inégalée, le vieil homme vous regarde avec un sourire chaleureux.%SPEECH_ON%Seuls ceux qui en sont dignes peuvent avoir la poignée de %weapon%. Seuls ceux qui vengeront mon fils et m\'apporteront sa lame seront dignes. Pour cela, vous devez trouver la bête.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Would this make me worthy?",
					function getResult( _event )
					{
						return "C2";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "C2",
			Text = "[img]gfx/ui/events/event_109.png[/img]{La lame de %weapon% vibre et bourdonne. Vous le tenez à deux mains, l\'acier ondule très légèrement sur vos doigts. Souriant une fois de plus, l\'aîné acquiesce et tourne sa main vers la poignée suspendue. Elle se soulève de son support et flotte à travers la pièce jusqu\'à vos mains. Là, le manche se détourne et se fond dans l\'acier, dans un éclair orange et bleu, l\'arme prend forme. C\'est l\'une des lames les plus incroyables que vous ayez jamais vues, avec des glyphes de lunes et d\'étoiles qui ornent son tranchant. Quand vous levez les yeux, vous pouvez voir à travers la poitrine de l\'aîné, il s\'efface progressivement.%SPEECH_ON%Mon fils a été vengé. Son esprit peut se reposer, et maintenant le mien aussi.%SPEECH_OFF%Vous regardez l\'épée s\'élever dans les airs, tourner avec l\'acier pointé vers le bas. Les armoires de la demeure s\'ouvrent, des lanières de cuir s\'envolent et s\'accrochent à des plans de reliure qui s\'assemblent pour former un fourreau.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je vais la prendre.",
					function getResult( _event )
					{
						return "D2";
					}

				}
			],
			function start( _event )
			{
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "misc.legendary_sword_blade")
					{
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Vous perdez  a " + item.getName()
						});
						break;
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D2",
			Text = "[img]gfx/ui/events/event_109.png[/img]{L\'%weapon% tombe alors et vous tendez le bras pour l\'attraper, une main fantomatique vous la dérobe. Vous levez les yeux pour voir l\'aîné dégainer la lame, révélant ses effets de feu et de glace comme si il l\'avait fait naître pendant une sombre nuit dans le spectre même de son acier. Il s\'étrangle de rire.%SPEECH_ON%\"Vengez mon fils!\" \"Soyez dignes!\" - Des bêtises pour les simples d\'esprit. Vous avez bien fait de courir après la carotte, mercenaire, et pour cela je vais vous tuer rapidement.%SPEECH_OFF%Les métaux présente dans la demeure se tordent et volent jusqu\'à l\'aîné, frappant férocement son corps comme s\'ils voulaient armer l\'enclume même qui les a fabriqués. Le costume d\'acier s\'assemble alors que son occupant croasse de rire. Des mains vous attrapent par les épaules et vous traînent hors de la maison. Vous êtes protégé par la compagnie %companyname%. Le viielle esprit tourne la tête.%SPEECH_ON%Une bande de crétins, c\'est ça? Partez, tout le monde, et vous serez épargnés. Je demande seulement que vous me laissiez le capitaine car j\'ai déjà promis sa mort.%SPEECH_OFF%%randombrother% dégaine son arme et le reste de la compagnie fait de même. L\'aîné brandit l\'épée crépusculaire en retour. Bien que l\'acier soit bien réel, le corps de l\'aîné ondule de droite à gauche comme un rideau à peine voilé par une nuit de lune. Il soupire et des morceaux d\'éther bleu s\'échappent de ses lèvres. Il tourne la lame pour que la pointe soit face à vous.%SPEECH_ON%Qu\'il en soit ainsi.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Au combat !",
					function getResult( _event )
					{
						this.World.State.getLastLocation().setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Zombies).getID());
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
		_vars.push([
			"weapon",
			"Reproach of the Old Gods"
		]);
	}

	function onDetermineStartScreen()
	{
		local hasBlade = false;
		local hasBeenHereBefore = this.World.Flags.get("IsWaterWheelVisited");
		local items = this.World.Assets.getStash().getItems();

		foreach( item in items )
		{
			if (item != null && item.getID() == "misc.legendary_sword_blade")
			{
				hasBlade = true;
				break;
			}
		}

		if (hasBlade)
		{
			if (hasBeenHereBefore)
			{
				return "A2";
			}
			else
			{
				return "C2";
			}
		}
		else
		{
			return "A";
		}
	}

	function onClear()
	{
	}

});

