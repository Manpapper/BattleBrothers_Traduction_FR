this.holywar_outro_south_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.crisis.holywar_outro_south";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_84.png[/img]{Vous vous souvenez que les adeptes du Gilder étaient autrefois unis dans leur quête d'éradication des anciens dieux. Une idée déplacée selon laquelle, s'ils satisfaisaient suffisamment leur Dieu, il poserait son œil puissant sur tous les ennemis de ses fidèles et les anéantirait. Au lieu de cela, le Gilded voient leur détermination mise à rude épreuve : ils ont perdu la guerre sainte. Des villes et des villages ont été brûlés, des totems sacrés profanés et des lieux sacrés pillés. Des foules de gens se déplacent dans les rues, se lamentant de temps à autre, sans intention précise, mais comme s'ils avaient perdu tout langage pour exprimer la douleur qu'ils doivent maintenant endurer. À l'occasion, un corps tombe d'en haut, ou bien les gardes sortent les cadavres du puits pour qu'un spectateur s'y jette. Quelques-uns se prosternent devant des reliques d'or, se laissant cuire sous l'éclat du soleil et des emblèmes brillants, les personnes en deuil rampant sous les reflets frémissants jusqu'à ce que leur peau se transforme en croûte et que leur gorge s'étouffe dans leur propre chair, et alors que le soleil va et vient, des corps gisent dans le sillage de son regard. Quant au %companyname%, vous vous êtes mis d'un côté ou de l'autre, et indépendamment des gagnants ou des perdants, vous avez fait une petite fortune. Pour l'avenir, vous ne devez pas non plus souhaiter que l'occasion se représente : s'il y a une chose que l'on sait d'un homme de foi, c'est que la défaite n'est qu'un coup sur le fer trempé. Avec tout ce que vous avez accompli, peut-être serait-il temps de retirer l'épée et de profiter de vos couronnes... Vous avez gagné ! Battle Brothers a été conçu pour être rejouable et pour que les campagnes soient jouées jusqu'à ce que vous ayez surmonté une ou deux crises de fin de partie. Commencer une nouvelle campagne vous permettra d'essayer différentes choses dans un monde différent. Vous pouvez également choisir de poursuivre votre campagne aussi longtemps que vous le souhaitez. Sachez simplement que les campagnes ne sont pas conçues pour durer éternellement et qu'il est probable que vous finissiez par manquer de défis.%OOC_OFF%}",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "%companyname% a besoin de son commandant!",
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
			Text = "[img]gfx/ui/events/event_84.png[/img]{La foi placée dans le Gilder a été récompensée : la guerre sainte est terminée, et les sudistes sont victorieux. Le vizir, les conseillers et le clergé se retrouvent dans les rues, chacun chevauchant de grands chariots qui, à la place des roues, sont hissés sur le dos des esclaves. Des esclaves du Nord, en particulier, redevables au doreur pour leurs crimes. On voit à peine les hommes, juste leurs jambes noires d'ombre comme si un cortège de scarabées se balançait. Les hommes riches et prodigues prennent de grands calices et lancent ce qui ressemble à de l'eau dorée sur les fidèles en liesse. Tu te penches toi-même vers l'une de ces éclaboussures, mais tu t'aperçois que ce n'est que de l'eau teintée. Alors que les fausses fortunes ne servaient qu'à étancher ta soif, la guerre bien réelle entre les fidèles des anciens dieux et les Dorés eux-mêmes servait à remplir le trésor du %companyname%. En tant que Crownling, vous ne trouverez jamais le respect des têtes nues et des corps courbés, ni les prosternations des paysans, ni l'éclat de l'or trop lourd à porter pour un seul homme. Telle est la réalité pour vous, mais cela n'empêchera pas la compagnie d'être prête la prochaine fois que les pieux voudront se chamailler sur la droiture. Ou peut-être est-ce le bon moment pour rengainer votre épée et profiter de vos couronnes ? Vous avez gagné ! Battle Brothers a été conçu pour être rejouable et pour que les campagnes soient jouées jusqu'à ce que vous ayez surmonté une ou deux crises de fin de partie. Commencer une nouvelle campagne vous permettra d'essayer différentes choses dans un monde différent. Vous pouvez également choisir de poursuivre votre campagne aussi longtemps que vous le souhaitez. Sachez simplement que les campagnes ne sont pas conçues pour durer éternellement et qu'il est probable que vous finissiez par manquer de défis.%OOC_OFF%}",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "%companyname% a besoin de son commandant!",
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

		if (currentTile.SquareCoords.Y > this.World.getMapSize().Y * 0.18)
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

