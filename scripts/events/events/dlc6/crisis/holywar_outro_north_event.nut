this.holywar_outro_north_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.holywar_outro_north";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_84.png[/img]{La foi placée dans les anciens dieux a été récompensée : la guerre sainte est terminée, et les Nordistes sont victorieux. Des chants emplissent l'air tandis que la foule se déplace, poings levés, drapeaux flottants, s'uniformisant brièvement dans un sentiment de piété partagé. Vous vous tenez sur le bord du chemin, les épaules déjà parées d'ornements, de perles, de colliers, d'objets sans valeur matérielle, et pourtant ils ont un poids que celui qui les porte ne peut trouver qu'en regardant dans les yeux de ceux qui les distribuent. Bien sûr, certaines dignités ne sont pas respectées lors de la célébration : les corps des vaincus sont exposés, battus de manière à satisfaire les anciens dieux qui veillent, et les totems sacrés des doreur sont moqués, profanés, et finalement brûlés. Et il est en effet certain qu'aucune âme joyeuse ne vous reconnaîtra comme une force dans cet heureux aboutissement. Vous vous êtes simplement glissé dans l'ombre une fois de plus, vendeur, couronné, intrus. Mais le %companyname% a fait une petite fortune dans les entreprises religieuses. Malgré les sourires et les rires, vous savez que de telles querelles sont enfouies dans l'esprit, pas dans la terre, et qu'un jour quelqu'un ou quelque chose viendra les ressusciter, et là, la compagnie attendra un autre glorieux jour de paie. Ou peut-être serait-ce le moment de retirer l'épée et de profiter de vos couronnes ? Vous avez gagné ! Battle Brothers a été conçu pour être rejouable et pour que les campagnes soient jouées jusqu'à ce que vous ayez surmonté une ou deux crises de fin de partie. Commencer une nouvelle campagne vous permettra d'essayer différentes choses dans un monde différent. Vous pouvez également choisir de poursuivre votre campagne aussi longtemps que vous le souhaitez. Sachez simplement que les campagnes ne sont pas conçues pour durer éternellement et qu'il est probable que vous finissiez par manquer de défis.%OOC_OFF%}",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "Le %companyname% a besoin de son commandant!",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Il est temps de se retirer de la vie de mercenaire. (End Campaign)",
					function getResult( _event )
					{
						this.World.State.getMenuStack().pop(true);
						this.World.State.showGameFinishScreen(true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Combat.abortAll();
				this.World.FactionManager.makeEveryoneFriendlyToPlayer();
				this.World.FactionManager.createAlliances();
				this.updateAchievement("CulturalMisunderstanding", 1, 1);

				if (this.World.Assets.isIronman())
				{
					this.updateAchievement("ManOfIron", 1, 1);
				}

				if (this.World.Assets.isIronman())
				{
					local defeated = this.getPersistentStat("CrisesDefeatedOnIronman");
					defeated = defeated | this.Const.World.GreaterEvilTypeBit.HolyWar;
					this.setPersistentStat("CrisesDefeatedOnIronman", defeated);

					if (defeated == this.Const.World.GreaterEvilTypeBit.All)
					{
						this.updateAchievement("Savior", 1, 1);
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_84.png[/img]{Tous
Actualités
Shopping
Vidéos
Images
Plus
Outils

Environ 2 300 000 000 résultats (0,33 secondes) 
Anglais
Français

Prononcer leur nom, c'est tirer des mots de la langue vers l'intemporel : les anciens dieux. Ils sont au-delà du temps, et leur grand nombre suscite la crainte de la spécificité. Aussi attachant que cela soit pour tout auditeur familier ou non avec la foi, cela donne également plus de poids à toute défaite de ceux qui suivent ces êtres sans marque. Les croisades sont terminées et les nordistes ont perdu.\n\n Vous regardez les nordistes essayer d'expliquer les uns aux autres comment cela s'est passé. Ce n'était pas une défaite terrestre ici, ni même une victoire des sudistes - non, c'était une punition. Les habitants du Nord ont pâturé loin des terres saintes, ils ont pâturé dans le monde matériel, les prieurés et les églises parsèment le royaume, vides et creux depuis bien trop longtemps. Naturellement, des demandes de renseignements sur la nature de ce doreur du sud sont également venues, mais elles passent rapidement. Ne serait-ce que s'attarder sur Lui, c'est inviter au doute, et en ce moment, le doute est aussi dangereux que n'importe quel poison. Bien entendu, la %companyname% reste à distance. Vendswords que vous êtes, vous avez mis la foi dans votre épée et dans la bourse, et les deux ont obtenu leur dû dans cette guerre. La seule philosophie que vous ferez dans les jours à venir est de vous demander à quel moment le nord et le sud recommenceront à énoncer leurs différences. Ce serait peut-être le bon moment pour lever l'épée et profiter de vos couronnes ? Vous avez gagné ! Battle Brothers est conçu pour être rejouable et pour que les campagnes soient jouées jusqu'à ce que vous ayez surmonté une ou deux crises de fin de partie. Commencer une nouvelle campagne vous permettra d'essayer différentes choses dans un monde différent. Vous pouvez également choisir de poursuivre votre campagne aussi longtemps que vous le souhaitez. Sachez simplement que les campagnes ne sont pas conçues pour durer éternellement et qu'il est probable que vous finissiez par manquer de défis.%OOC_OFF%}",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "la %companyname% a besoin de leur commandant!",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Il est temps de se retirer de la vie de mercenaire. (End Campaign)",
					function getResult( _event )
					{
						this.World.State.getMenuStack().pop(true);
						this.World.State.showGameFinishScreen(true);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Combat.abortAll();
				this.World.FactionManager.makeEveryoneFriendlyToPlayer();
				this.World.FactionManager.createAlliances();
				this.updateAchievement("CulturalMisunderstanding", 1, 1);

				if (this.World.Assets.isIronman())
				{
					this.updateAchievement("ManOfIron", 1, 1);
				}

				if (this.World.Assets.isIronman())
				{
					local defeated = this.getPersistentStat("CrisesDefeatedOnIronman");
					defeated = defeated | this.Const.World.GreaterEvilTypeBit.HolyWar;
					this.setPersistentStat("CrisesDefeatedOnIronman", defeated);

					if (defeated == this.Const.World.GreaterEvilTypeBit.All)
					{
						this.updateAchievement("Savior", 1, 1);
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.18)
		{
			return;
		}

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.Contracts.getActiveContract() != null)
		{
			return;
		}

		if (this.World.Statistics.hasNews("crisis_holywar_end"))
		{
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_holywar_end");
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		local north = 0;
		local south = 0;
		local sites = [
			"location.holy_site.oracle",
			"location.holy_site.meteorite",
			"location.holy_site.vulcano"
		];
		local locations = this.World.EntityManager.getLocations();

		foreach( v in locations )
		{
			foreach( i, s in sites )
			{
				if (v.getTypeID() == s && v.getFaction() != 0)
				{
					if (this.World.FactionManager.getFaction(v.getFaction()).getType() == this.Const.FactionType.NobleHouse)
					{
						north = ++north;
					}
					else
					{
						south = ++south;
					}
				}
			}
		}

		if (north >= south)
		{
			return "A";
		}
		else
		{
			return "B";
		}
	}

	function onClear()
	{
	}

});

