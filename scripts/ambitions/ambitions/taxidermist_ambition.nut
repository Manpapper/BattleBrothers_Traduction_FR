this.taxidermist_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.taxidermist";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Rien n\'inspire plus le respect qu\'un trophée d\'une bête géante des étendues gelées.\nAllons chasser et donner du travail au taxidermiste !";
		this.m.UIText = "Créer des objets chez le taxidermiste";
		this.m.TooltipText = "Avoir au moins 12 objets fabriqués à partir de trophées de bêtes chez le taxidermiste. On peut trouver un taxidermiste dans les campements situés près des forêts et des marais, et il peut fabriquer des objets utiles à partir de trophées de bêtes, comme les peaux de loups exceptionnellement grandes que laissent tomber les loups-garous.";
		this.m.SuccessText = "[img]gfx/ui/events/event_97.png[/img]Un jeune garçon vous interpelle et vous demande si vous êtes le chef de %companyname%. Regardant les environs, vous lui demandez si c\'est pour lui. Il hausse les épaules.%SPEECH_ON%Eh bien, je ne veux rien dire par là, monsieur. Si je le trouve et le ramène, je suis payé trois pièces d\'or. C\'est tout.%SPEECH_OFF%Intrigué, vous demandez qui est censé payer cette récompense. Le garçon est en train de ramasser une crotte de nez et regarde en l\'air.%SPEECH_ON%Qu\'est-ce que c\'est ? Ah, je n\'ai pas encore vu l\'or ! Il faut d\'abord trouver l\'homme !%SPEECH_OFF%Soupirant, vous écartez la main du garçon, morve et tout, et lui demandez à nouveau. Le garçon renifle, réfléchit, regarde la terre, les vers qui s\'y trouvent. Il hoche la tête. %SPEECH_ON%C\'était un percepteur. Pas le genre à ramasser l\'or. Il ne me paierait pas une pièce, cet homme est un diable aux longs doigts, d\'après mon père. Je parle du percepteur des animaux. Il dépouille les animaux et fabrique quelque chose de féroce avec, manteaux, couvertures, poisons, alcools. Ce percepteur. Eh bien, ils se parlent tous entre eux. Ils disent que le travail de %companyname% est la meilleure affaire du pays et ils ont tous hâte de les revoir!%SPEECH_OFF%Ah, il parle des taxidermistes. En souriant, vous tapotez la tête du garçon et lui souhaitez bonne chance pour sa chasse.%SPEECH_ON%La chance n\'a pas grand-chose à voir là-dedans, je veux trouver cet homme de façon intelligente. Je garde les yeux ouverts, les oreilles attentives et mon pantalon haut et serré.%SPEECH_OFF%";
		this.m.SuccessButtonText = "%companyname% présente fièrement ses trophées.";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.Math.min(12, this.World.Statistics.getFlags().get("ItemsCrafted")) + "/12)";
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		if (this.World.Statistics.getFlags().get("ItemsCrafted") >= 12)
		{
			this.m.IsDone = true;
			return;
		}

		this.m.Score = 1 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		return this.World.Statistics.getFlags().get("ItemsCrafted") >= 12;
	}

	function onPrepareVariables( _vars )
	{
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
	}

});

