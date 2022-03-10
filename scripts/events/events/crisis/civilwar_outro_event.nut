this.civilwar_outro_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null
	},
	function create()
	{
		this.m.ID = "event.crisis.civilwar_outro";
		this.m.Title = "Pendant le campement...";
		this.m.Cooldown = 1.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_96.png[/img]Tu es dans ta tente quand %dude% fait une entrée. Il parle franchement.%SPEECH_ON%Les Nobles parlent. Ils sont dans la grande tente fantaisiste installée là-bas.%SPEECH_OFF%En posant votre plume, vous répondez.%SPEECH_ON%Parlez simplement ?%SPEECH_OFF%Le mercenaire hausse les épaules.%SPEECH_ON%C\'est calme. Donc, soit ils parlent, soit ils s\'entretuent très silencieusement.%SPEECH_OFF%Vous vous levez et sortez. Un air vif vous frappe, et il y a un parfum d\'épices et de saveurs. En regardant au loin, vous apercevez la tente. Les cuisiniers et les chefs se pressent avec des commandes de nourriture et d\'autres préparations. Les serviteurs portent des plateaux de viandes, de légumes et de fruits. Une tente cossue, noire brodée d\'or, abrite les nobles. Les bannerets se tiennent à l\'extérieur. Ils ne participent pas aux festivités. Ils jouent principalement aux cartes tout en se regardant de temps en temps. Certains sont bandés avec des draps tachés de sang. Un homme se tient sur des béquilles avec un air hagard et à moitié en armure. Vous demandez à %dude% quelles sont les nouvelles. Il fait un signe de tête vers la scène.%SPEECH_ON%Eh bien, ils sont arrivés il y a environ une heure pendant que vous vérifiiez les cartes. Nous ne voulions pas vous déranger, mais, eh bien, ils semblaient déterminés à rester, vous savez.%SPEECH_OFF%Vous obtenez un bon aperçu de la tente. Par son ouverture, on aperçoit le faible scintillement des têtes couronnées qui passent et repassent. %dude% crache et demande.%SPEECH_ON%Eh bien, qui pensez-vous a gagné la guerre ?%SPEECH_OFF%Vous mettez un manteau, crachez et secouez la tête.%SPEECH_ON%Qui s\'en fout ?%SPEECH_OFF%Tout ce qui compte pour vous c\'est que la paix signifie moins de contrats. Ce serait peut-être le bon moment pour ranger l\'épée et profiter de vos couronnes ? Ou peut-être dire, au diable toutes ces conneries sentimentales et continuer à avancer, menant la compagnie vers des aventures encore plus grandes ?\n\n%OOC%Vous avez gagné ! Battle Brothers est conçu pour la rejouabilité et pour que les campagnes soient jouées jusqu\'à ce que vous ayez vaincu une ou deux crises de fin de partie. Lancer une nouvelle campagne vous permettra d\'essayer différentes choses dans un monde différent.\n\nVous pouvez également choisir de poursuivre votre campagne aussi longtemps que vous le souhaitez. Sachez simplement que les campagnes ne sont pas destinées à durer éternellement et que vous finirez probablement par manquer de défis.%OOC_OFF%",
			Image = "",
			Characters = [],
			Options = [
				{
					Text = "La %companyname% a besoin de son commandant !",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Il est temps de se retirer de la vie de mercenaire. (Fin de campagne)",
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
				this.Characters.push(_event.m.Dude.getImagePath());
				this.World.Combat.abortAll();
				this.World.FactionManager.makeEveryoneFriendlyToPlayer();
				this.World.FactionManager.createAlliances();
				this.updateAchievement("Kingmaker", 1, 1);

				if (this.World.Assets.isIronman())
				{
					this.updateAchievement("ManOfIron", 1, 1);
				}

				if (this.World.Assets.isIronman())
				{
					local defeated = this.getPersistentStat("CrisesDefeatedOnIronman");
					defeated = defeated | this.Const.World.GreaterEvilTypeBit.CivilWar;
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
		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.Const.DLC.Desert && currentTile.SquareCoords.Y <= this.World.getMapSize().Y * 0.2)
		{
			return;
		}

		if (this.World.Statistics.hasNews("crisis_civilwar_end"))
		{
			local brothers = this.World.getPlayerRoster().getAll();
			local most_days_with_company = -9000.0;
			local most_days_with_company_bro;

			foreach( bro in brothers )
			{
				if (bro.getDaysWithCompany() > most_days_with_company)
				{
					most_days_with_company = bro.getDaysWithCompany();
					most_days_with_company_bro = bro;
				}
			}

			this.m.Dude = most_days_with_company_bro;
			this.m.Score = 6000;
		}
	}

	function onPrepare()
	{
		this.World.Statistics.popNews("crisis_civilwar_end");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dude",
			this.m.Dude.getNameOnly()
		]);
		local nobles = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse);
		_vars.push([
			"randomnoblehouse",
			nobles[this.Math.rand(0, nobles.len() - 1)].getName()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
	}

});

